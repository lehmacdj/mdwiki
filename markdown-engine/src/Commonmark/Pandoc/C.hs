{-# LANGUAGE Haskell2010 #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE ViewPatterns #-}

-- {-# OPTIONS_GHC -fllvm #-}

module Commonmark.Pandoc.C where

import Commonmark
import Commonmark.Pandoc
import Control.Applicative
import Control.Monad
import Data.Aeson (ToJSON (..))
import qualified Data.Aeson as Json
import Data.Attoparsec.ByteString.Char8
import qualified Data.Attoparsec.Text as APT
import Data.Bifunctor (first, second)
import Data.ByteString (ByteString)
import Data.ByteString.Char8 as B
import Data.ByteString.Internal as BI
import qualified Data.ByteString.Lazy as BL
import Data.Functor
import Data.List (lookup)
import Data.Text as T
import Data.Text (Text)
import qualified Data.Text.Encoding as E
import qualified Data.Text.Encoding.Error as E
import qualified Data.Yaml.Aeson as Yaml
import Foreign
import Foreign.C (CString, newCString)
import GHC.Ptr (Ptr (..))
import Text.Pandoc.Builder (Blocks)
import qualified Text.Pandoc.Builder as PB
import Text.Pandoc.Definition
import Text.Pandoc.Walk

foreign export ccall "try_parse_commonmark_json_api" try_parse_commonmark_json_api :: CString -> IO CString

-- | Parse a string representing a markdown document into a pandoc ast along
-- with some extra meta data.
-- where the boolean value says if there were parse errors and the **char is
-- assigned a new allocated string that is either:
-- * if parsed correctly json representing the Pandoc AST
-- * if parsing failed a json error message (format to be determined)
--
-- There are a couple of improvements that should be done for a future version
-- of this api:
-- * This json api is probably slow, it could be improved to a faster one
-- based on c structs directly eventually, but for now, we are more interested
-- getting a proof of concept so the simplicity of this approach and lack of
-- likelyhood to segfault makes this approach preferable.
try_parse_commonmark_json_api ::
  CString -> IO CString
try_parse_commonmark_json_api input = do
  document <- B.packCString input
  case parseDocument document of
    Right parsedDocument -> newCStringFromBS (render parsedDocument)
    Left err -> newCStringFromBS (renderError err)

decodeUtf8 :: ByteString -> Text
decodeUtf8 = E.decodeUtf8With E.lenientDecode

-- | used in doScan within parseFrontmatter only
-- the Int in 1 <= WantDash <= 3 at all times and represents the number of
-- dashes that are still expected
data ScanState
  = WantStartNewline
  | WantDash !Int
  | WantFinalNewline

-- | returns the frontmatter to be parsed as YAML + an offset in newlines that
-- were parsed.
parseFrontmatter :: Parser (ByteString, Int)
parseFrontmatter = do
  _ <- string "---\n"
  let doScan WantStartNewline '\n' = Just $ WantDash 3
      doScan (WantDash n) '-'
        | n == 1 = Just WantFinalNewline
        | n == 2 || n == 3 = Just $ WantDash (n - 1)
        | otherwise = error "invalid state"
      doScan WantFinalNewline '\n' = Nothing
      doScan _ _ = Just WantStartNewline
  frontmatter <- scan WantStartNewline doScan
  let newlinesInYaml = countCharsInStr '\n' frontmatter
  -- @optimization: it might be possible to avoid concattenating the "\n" at the
  -- end of the string here. But its not worth messing with this unless we
  -- really need to squeeze performance out of this + probably after
  -- benchmarking
  pure (frontmatter <> "\n", newlinesInYaml + 3)
  where
    countCharsInStr c = B.length . B.filter (== c)

-- | Parser for a complete markdown document. This has special handling for the
-- byteOrderMark which is allowed to be at the start of the document here.
-- returns the header which should be parsed as YAML, an offset in lines that
-- should be used to adjust the line numbers of the markdown in Left or just
-- the markdown as text in Right
separateFrontmatterAndBody ::
  ByteString -> Either MyParseError (Either (ByteString, Int, Text) Text)
separateFrontmatterAndBody = first SeparationParseError . parseOnly parser
  where
    byteOrderMark = "\xef\xbb\xbf"
    parser =
      do
        _ <- optional byteOrderMark
        mFrontmatter <- optional parseFrontmatter
        let mkResult markdown = case mFrontmatter of
              Just (frontmatter, offset) -> Left (frontmatter, offset, markdown)
              Nothing -> Right markdown
        markdownText <- decodeUtf8 <$> takeByteString
        pure $ mkResult markdownText

-- | Copies 'ByteString' to newly allocated 'CString'. The result must be
-- explicitly freed using 'free' or 'finalizerFree'.
-- copied from: hsass-0.8.0.0 package
newCStringFromBS :: ByteString -> IO CString
newCStringFromBS (BI.PS fp o l) = do
  buf <- mallocBytes (l + 1)
  withForeignPtr fp $ \p -> do
    BI.memcpy buf (p `plusPtr` o) (fromIntegral l)
    pokeByteOff buf l (0 :: Word8)
    return $ castPtr buf

data MyParseError
  = SeparationParseError String
  | JsonParseError ParseError
  | -- | Takes first a string representing the attr in which the source range
    -- failed to parse then the error message produced by Attoparsec
    SourceRangeParseError String String
  | CommonmarkParseError ParseError
  | UnspecifiedError
  deriving (Show)

instance ToJSON MyParseError where
  toJSON = undefined
  toEncoding = undefined

render :: Pandoc -> ByteString
render = BL.toStrict . Json.encode

renderError :: MyParseError -> ByteString
renderError = B.pack . show

tshow :: Show a => a -> Text
tshow = T.pack . show

data SimpleSourceRange = SimpleSourceRange
  { sourceRangeFilename :: Text,
    sourceRangeLineStart :: Int,
    sourceRangeColumnStart :: Int,
    sourceRangeLineEnd :: Int,
    sourceRangeColumnEnd :: Int
  }
  deriving (Eq)

renderSourceRange :: SimpleSourceRange -> Text
renderSourceRange (SimpleSourceRange fn ls cs le ce) =
  fn <> "@" <> tshow ls <> ":" <> tshow cs <> "-" <> tshow le <> ":" <> tshow ce

-- | takes a string representation of the span that this source range, and the
-- Text representing the source range and parses it, or produces an error
parseSourceRange :: String -> Text -> Either MyParseError SimpleSourceRange
parseSourceRange spanStr =
  first (SourceRangeParseError spanStr) . APT.parseOnly sourceRangeP
  where
    sourceRangeP =
      SimpleSourceRange
        <$> (APT.takeWhile (/= '@') <* APT.string "@")
        <*> (APT.decimal <* lcSep)
        <*> (APT.decimal <* seSep)
        <*> (APT.decimal <* lcSep)
        <*> (APT.decimal <* APT.endOfInput)
    lcSep = APT.string ":" $> ()
    seSep = APT.string "-" $> ()

-- | add a number of lines to the start and end of the range
plusLines :: SimpleSourceRange -> Int -> SimpleSourceRange
plusLines (SimpleSourceRange fn ls cs le ce) offset =
  SimpleSourceRange fn (ls + offset) cs (le + offset) ce

attrSetKey :: Text -> Text -> Attr -> Attr
attrSetKey = undefined

parseDocument :: ByteString -> Either MyParseError Pandoc
parseDocument input = do
  separated <- separateFrontmatterAndBody input
  let makeMeta (frontmatter, offset, body) =
        (,offset,body) <$> yamlHeaderToMeta frontmatter
  (meta, offset, body) <- either makeMeta (Right . (mempty,0,)) separated
  blocks <- commonmarkToPandocBlocks body
  let offsetDataPos = \case
        Span attr@(_, _, lookup "data-pos" -> Just srText) contents -> do
          sourceRange <- parseSourceRange (show attr) srText
          let newSrText = renderSourceRange (sourceRange `plusLines` offset)
              attr' = attrSetKey "data-pos" newSrText attr
          pure $ Span attr' contents
        x -> pure x
  -- posAdjustedBlocks <- walkM offsetDataPos blocks
  pure $ Pandoc meta blocks

-- | use YAML parsing library to parse YAML header into YAML fields
-- TODO: actually parse YAML Frontmatter instead of just returning an empty
-- meta block
yamlHeaderToMeta :: ByteString -> Either MyParseError Meta
yamlHeaderToMeta _ = Right mempty

commonmarkToPandocBlocks ::
  Text ->
  Either MyParseError [Block]
commonmarkToPandocBlocks text =
  case parseCommonmarkWith defaultSyntaxSpec (tokenize "source" text) of
    Just (Right ast) ->
      Right
        . PB.toList
        . unCm
        $ (ast :: Cm SourceRange Blocks)
    Just (Left err) -> Left . CommonmarkParseError $ err
    Nothing -> Left UnspecifiedError
