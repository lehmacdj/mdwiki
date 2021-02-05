{-# LANGUAGE Haskell2010 #-}
{-# LANGUAGE OverloadedStrings #-}

-- {-# OPTIONS_GHC -fllvm #-}

module Commonmark.Pandoc.C where

import Commonmark
import Commonmark.Pandoc
import Control.Applicative
import Control.Monad
import Data.Aeson (ToJSON (..))
import qualified Data.Aeson as Json
import Data.Attoparsec.ByteString.Char8
import Data.Bifunctor (first, second)
import Data.ByteString (ByteString)
import Data.ByteString.Char8 as B
import Data.ByteString.Internal as BI
import qualified Data.ByteString.Lazy as BL
import Data.Text
import qualified Data.Text.Encoding as E
import qualified Data.Text.Encoding.Error as E
import qualified Data.Yaml.Aeson as Yaml
import Foreign
import Foreign.C (CString, newCString)
import GHC.Ptr (Ptr (..))
import Text.Pandoc.Builder (Blocks)
import qualified Text.Pandoc.Builder as PB
import Text.Pandoc.Definition (Block, Meta (..), Pandoc (..))

-- foreign export ccall "try_parse_commonmark" try_parse_commonmark :: CString -> Ptr CString -> IO Bool

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
  CString -> Ptr CString -> IO Bool
try_parse_commonmark_json_api input outStrPtr = do
  document <- B.packCString input
  case parseDocument document of
    Right parsedDocument -> do
      outStr <- newCStringFromBS (render parsedDocument)
      poke outStrPtr outStr
      pure True
    Left err -> do
      outStr <- newCStringFromBS (renderError err)
      poke outStrPtr outStr
      pure False

{- HLint: ignore "Use camelCase" -}

decodeUtf8 :: ByteString -> Text
decodeUtf8 = E.decodeUtf8With E.lenientDecode

-- | used in doScan within parseFrontmatter only
-- the Int in 1 <= WantDash <= 3 at all times and represents the number of
-- dashes that are still expected
data ScanState
  = WantDash !Int
  | WantNewline

-- | returns the frontmatter to be parsed as YAML + an offset in newlines that
-- were parsed.
parseFrontmatter :: Parser (ByteString, Int)
parseFrontmatter = do
  _ <- string "---\n"
  let doScan (WantDash n) '-'
        | n == 1 = Just WantNewline
        | n == 2 || n == 3 = Just $ WantDash (n - 1)
        | otherwise = error "invalid state"
      doScan WantNewline '\n' = Nothing
      doScan _ _ = Just $ WantDash 3
  frontmatter <- scan (WantDash 3) doScan
  let newlinesInYaml = countCharsInStr '\n' frontmatter
  pure (frontmatter, newlinesInYaml + 2)
  where
    countCharsInStr c = B.length . B.filter (== c)

-- | Parser for a complete markdown document. This has special handling for the
-- byteOrderMark which is allowed to be at the start of the document here.
-- returns the header which should be parsed as YAML, an offset in lines that
-- should be used to adjust the line numbers of the markdown in Left or just
-- the markdown as text in Right
parseMarkdownDocument :: Parser (Either (ByteString, Int, Text) Text)
parseMarkdownDocument = do
  _ <- optional byteOrderMark
  mFrontmatter <- optional parseFrontmatter
  let mkResult markdown = case mFrontmatter of
        Just (frontmatter, offset) -> Left (frontmatter, offset, markdown)
        Nothing -> Right markdown
  markdownText <- decodeUtf8 <$> takeByteString
  pure $ mkResult markdownText
  where
    byteOrderMark = "\xef\xbb\xbf"

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

data MyParseError = ParseError ParseError | UnspecifiedError

instance ToJSON MyParseError where
  toJSON = undefined
  toEncoding = undefined

render :: Pandoc -> ByteString
render = undefined

renderError :: MyParseError -> ByteString
renderError = undefined

-- | TODO: use Pandoc to separate header from markdown body and then parse both
-- separately using their own parser function followed by returning the
-- complete 'ParsedCommonmark'.
--
-- * the source annotations will need to be adjusted for the size of the yaml header
-- * the yaml header should be optional, i.e. parsing should not fail if it
-- is completely missing
-- * title of the markdown note (the first H1 in the document) should also be
-- added to the metadata as the title, unless there is already a title field
-- there
parseDocument :: ByteString -> Either MyParseError Pandoc
parseDocument = undefined

-- | use YAML parsing library to parse YAML header into YAML fields
yamlHeaderToMeta :: Text -> Either MyParseError Meta
yamlHeaderToMeta = undefined

commonmarkToPandocJson ::
  Text ->
  Either MyParseError [Block]
commonmarkToPandocJson text =
  case parseCommonmarkWith defaultSyntaxSpec (tokenize "source" text) of
    Just (Right ast) ->
      Right
        . PB.toList
        . unCm
        $ (ast :: Cm SourceRange Blocks)
    Just (Left err) -> Left . ParseError $ err
    Nothing -> Left UnspecifiedError
