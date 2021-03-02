//
//  TestData.swift
//  pandoc-types-tests
//
//  Created by Devin Lehmacher on 2/18/21.
//

/// The version of pandoc json that this test data is for.
let testDataPandocApiVersion = [1,22]

let emptyPandocJson = """
{
  "pandoc-api-version": [1,22],
  "meta": {},
  "blocks": []
}
"""

let simpleContentPandocJson = """
{
  "pandoc-api-version": [1, 22],
  "meta": {},
  "blocks": [
    {
      "t": "Div",
      "c": [
        ["", [], [["data-pos", "source@1:1-2:1"]]],
        [
          {
            "t": "Para",
            "c": [
              {
                "t": "Span",
                "c": [
                  ["", [], [["data-pos", "source@1:1-1:3"]]],
                  [
                    {
                      "t": "Str",
                      "c": "Hi"
                    }
                  ]
                ]
              }
            ]
          }
        ]
      ]
    }
  ]
}
"""

/// Haskell Type: Meta
/// Haskell Term:
/// Meta $ M.fromList [("foo", MetaBool True)]
let meta = """
{"foo":{"t":"MetaBool","c":true}}
"""

/// Haskell Type: MetaValue
/// Haskell Term:
/// MetaMap $ M.fromList [("foo", MetaBool True)]
let metamap = """
{"t":"MetaMap","c":{"foo":{"t":"MetaBool","c":true}}}
"""

/// Haskell Type: MetaValue
/// Haskell Term:
/// MetaList [MetaBool True, MetaString "baz"]
let metalist = """
{"t":"MetaList","c":[{"t":"MetaBool","c":true},{"t":"MetaString","c":"baz"}]}
"""

/// Haskell Type: MetaValue
/// Haskell Term:
/// MetaBool False
let metabool = """
{"t":"MetaBool","c":false}
"""

/// Haskell Type: MetaValue
/// Haskell Term:
/// MetaString "Hello"
let metastring = """
{"t":"MetaString","c":"Hello"}
"""

/// Haskell Type: MetaValue
/// Haskell Term:
/// MetaInlines [Space, SoftBreak]
let metainlines = """
{"t":"MetaInlines","c":[{"t":"Space"},{"t":"SoftBreak"}]}
"""

/// Haskell Type: MetaValue
/// Haskell Term:
/// MetaBlocks [Null,Null]
let metablocks = """
{"t":"MetaBlocks","c":[{"t":"Null"},{"t":"Null"}]}
"""

/// Haskell Type: QuoteType
/// Haskell Term:
/// SingleQuote
let singlequote = """
{"t":"SingleQuote"}
"""

/// Haskell Type: QuoteType
/// Haskell Term:
/// DoubleQuote
let doublequote = """
{"t":"DoubleQuote"}
"""

/// Haskell Type: CitationMode
/// Haskell Term:
/// AuthorInText
let authorintext = """
{"t":"AuthorInText"}
"""

/// Haskell Type: CitationMode
/// Haskell Term:
/// SuppressAuthor
let suppressauthor = """
{"t":"SuppressAuthor"}
"""

/// Haskell Type: CitationMode
/// Haskell Term:
/// NormalCitation
let normalcitation = """
{"t":"NormalCitation"}
"""

/// Haskell Type: Citation
/// Haskell Term:
/// Citation { citationId = "jameson:unconscious",
////           citationPrefix = [Str "cf"],
///            citationSuffix = [Space,Str "123"],
///            citationMode = NormalCitation,
///            citationNoteNum = 0,
///            citationHash = 0}
let citation = """
{"citationId":"jameson:unconscious","citationPrefix":[{"t":"Str","c":"cf"}],"citationSuffix":[{"t":"Space"},{"t":"Str","c":"123"}],"citationMode":{"t":"NormalCitation"},"citationNoteNum":0,"citationHash":0}
"""

/// Haskell Type: MathType
/// Haskell Term:
/// DisplayMath
let displaymath = """
{"t":"DisplayMath"}
"""

/// Haskell Type: MathType
/// Haskell Term:
/// InlineMath
let inlinemath = """
{"t":"InlineMath"}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Str "Hello"
let str = """
{"t":"Str","c":"Hello"}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Emph [Str "Hello"]
let emph = """
{"t":"Emph","c":[{"t":"Str","c":"Hello"}]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Underline [Str "Hello"]
let underline = """
{"t":"Underline","c":[{"t":"Str","c":"Hello"}]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Strong [Str "Hello"]
let strong = """
{"t":"Strong","c":[{"t":"Str","c":"Hello"}]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Strikeout [Str "Hello"]
let strikeout = """
{"t":"Strikeout","c":[{"t":"Str","c":"Hello"}]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Superscript [Str "Hello"]
let superscript = """
{"t":"Superscript","c":[{"t":"Str","c":"Hello"}]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Subscript [Str "Hello"]
let `subscript` = """
{"t":"Subscript","c":[{"t":"Str","c":"Hello"}]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// SmallCaps [Str "Hello"]
let smallcaps = """
{"t":"SmallCaps","c":[{"t":"Str","c":"Hello"}]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Quoted SingleQuote [Str "Hello"]
let quoted = """
{"t":"Quoted","c":[{"t":"SingleQuote"},[{"t":"Str","c":"Hello"}]]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Cite [Citation { citationId = "jameson:unconscious"
///                , citationPrefix = [Str "cf"]
///                , citationSuffix = [Space,Str "12"]
///                , citationMode = NormalCitation
///                , citationNoteNum = 0
///                , citationHash = 0}]
///      [ Str "[cf"
///      , Space
///      , Str "@jameson:unconscious"
///      , Space
///      , Str "12]"]
let cite = """
{"t":"Cite","c":[[{"citationId":"jameson:unconscious","citationPrefix":[{"t":"Str","c":"cf"}],"citationSuffix":[{"t":"Space"},{"t":"Str","c":"12"}],"citationMode":{"t":"NormalCitation"},"citationNoteNum":0,"citationHash":0}],[{"t":"Str","c":"[cf"},{"t":"Space"},{"t":"Str","c":"@jameson:unconscious"},{"t":"Space"},{"t":"Str","c":"12]"}]]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Code ("", [], [("language", "haskell")]) "foo bar"
let code = """
{"t":"Code","c":[["",[],[["language","haskell"]]],"foo bar"]}
"""


/// Haskell Type: Inline
/// Haskell Term:
/// Space
let space = """
{"t":"Space"}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// SoftBreak
let softbreak = """
{"t":"SoftBreak"}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// LineBreak
let linebreak = """
{"t":"LineBreak"}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// RawInline (Format "tex") "\\foo{bar}"
let rawinline = """
{"t":"RawInline","c":["tex","\\foo{bar}"]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Link ("id",["kls"],[("k1", "v1"), ("k2", "v2")])
/// [ Str "a", Space, Str "famous", Space, Str "site"]
/// ("https://www.google.com","google")
let link = """
{"t":"Link","c":[["id",["kls"],[["k1","v1"],["k2","v2"]]],[{"t":"Str","c":"a"},{"t":"Space"},{"t":"Str","c":"famous"},{"t":"Space"},{"t":"Str","c":"site"}],["https://www.google.com","google"]]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Image ("id",["kls"],[("k1", "v1"), ("k2", "v2")])
/// [ Str "a", Space, Str "famous", Space, Str "image"]
/// ("my_img.png","image")
let image = """
{"t":"Image","c":[["id",["kls"],[["k1","v1"],["k2","v2"]]],[{"t":"Str","c":"a"},{"t":"Space"},{"t":"Str","c":"famous"},{"t":"Space"},{"t":"Str","c":"image"}],["my_img.png","image"]]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Note [Para [Str "Hello"]]
let note = """
{"t":"Note","c":[{"t":"Para","c":[{"t":"Str","c":"Hello"}]}]}
"""

/// Haskell Type: Inline
/// Haskell Term:
/// Span ("id", ["kls"], [("k1", "v1"), ("k2", "v2")]) [Str "Hello"]
let span = """
{"t":"Span","c":[["id",["kls"],[["k1","v1"],["k2","v2"]]],[{"t":"Str","c":"Hello"}]]}
"""



/// Haskell Type: Block
/// Haskell Term:
/// Plain [Str "Hello"]
let plain = """
{"t":"Plain","c":[{"t":"Str","c":"Hello"}]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// Para [Str "Hello"]
let para = """
{"t":"Para","c":[{"t":"Str","c":"Hello"}]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// LineBlock [[Str "Hello"], [Str "Moin"]]
let lineblock = """
{"t":"LineBlock","c":[[{"t":"Str","c":"Hello"}],[{"t":"Str","c":"Moin"}]]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// CodeBlock ("id", ["kls"], [("k1", "v1"), ("k2", "v2")]) "Foo Bar"
let codeblock = """
{"t":"CodeBlock","c":[["id",["kls"],[["k1","v1"],["k2","v2"]]],"Foo Bar"]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// RawBlock (Format "tex") "\\foo{bar}"
let rawblock = """
{"t":"RawBlock","c":["tex","\\foo{bar}"]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// BlockQuote [Para [Str "Hello"]]
let blockquote = """
{"t":"BlockQuote","c":[{"t":"Para","c":[{"t":"Str","c":"Hello"}]}]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// OrderedList (1,Decimal,Period)
/// [[Para [Str "foo"]]
/// ,[Para [Str "bar"]]]
let orderedlist = """
{"t":"OrderedList","c":[[1,{"t":"Decimal"},{"t":"Period"}],[[{"t":"Para","c":[{"t":"Str","c":"foo"}]}],[{"t":"Para","c":[{"t":"Str","c":"bar"}]}]]]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// BulletList
/// [[Para [Str "foo"]]
/// ,[Para [Str "bar"]]]
let bulletlist = """
{"t":"BulletList","c":[[{"t":"Para","c":[{"t":"Str","c":"foo"}]}],[{"t":"Para","c":[{"t":"Str","c":"bar"}]}]]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// DefinitionList
/// [([Str "foo"],
///   [[Para [Str "bar"]]])
/// ,([Str "fizz"],
///   [[Para [Str "pop"]]])]
let definitionlist = """
{"t":"DefinitionList","c":[[[{"t":"Str","c":"foo"}],[[{"t":"Para","c":[{"t":"Str","c":"bar"}]}]]],[[{"t":"Str","c":"fizz"}],[[{"t":"Para","c":[{"t":"Str","c":"pop"}]}]]]]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// Header 2 ("id", ["kls"], [("k1", "v1"), ("k2", "v2")]) [Str "Head"]
let header = """
{"t":"Header","c":[2,["id",["kls"],[["k1","v1"],["k2","v2"]]],[{"t":"Str","c":"Head"}]]}
"""

/// Haskell Type: Row
/// Haskell Term:
/// Row ("id",["kls"],[("k1", "v1"), ("k2", "v2")])
/// [Cell ("", [], []) AlignRight 2 3 [Para [Str "bar"]]]
let row = """
[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[["",[],[]],{"t":"AlignRight"},2,3,[{"t":"Para","c":[{"t":"Str","c":"bar"}]}]]]]
"""

/// Haskell Type: Caption
/// Haskell Term:
/// Caption (Just [Str "foo"]) [Para [Str "bar"]]
let caption = """
[[{"t":"Str","c":"foo"}],[{"t":"Para","c":[{"t":"Str","c":"bar"}]}]]
"""

/// Haskell Type: TableHead
/// Haskell Term:
/// TableHead ("id",["kls"],[("k1", "v1"), ("k2", "v2")])
/// [Row ("id",["kls"],[("k1", "v1"), ("k2", "v2")]) []]
let tablehead = """
[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[["id",["kls"],[["k1","v1"],["k2","v2"]]],[]]]]
"""

/// Haskell Type: TableBody
/// Haskell Term:
/// TableBody ("id",["kls"],[("k1", "v1"), ("k2", "v2")]) 3
/// [Row ("id",["kls"],[("k1", "v1"), ("k2", "v2")]) []]
/// [Row ("id'",["kls'"],[("k1", "v1"), ("k2", "v2")]) []]
let tablebody = """
[["id",["kls"],[["k1","v1"],["k2","v2"]]],3,[[["id",["kls"],[["k1","v1"],["k2","v2"]]],[]]],[[["id'",["kls'"],[["k1","v1"],["k2","v2"]]],[]]]]
"""

/// Haskell Type: TableFoot
/// Haskell Term:
/// TableFoot ("id",["kls"],[("k1", "v1"), ("k2", "v2")])
/// [Row ("id",["kls"],[("k1", "v1"), ("k2", "v2")]) []]
let tablefoot = """
[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[["id",["kls"],[["k1","v1"],["k2","v2"]]],[]]]]
"""

/// Haskell Type: Cell
/// Haskell Term:
/// Cell ("id",["kls"],[("k1", "v1"), ("k2", "v2")]) AlignLeft 1 1
/// [Para [Str "bar"]]
let cell = """
[["id",["kls"],[["k1","v1"],["k2","v2"]]],{"t":"AlignLeft"},1,1,[{"t":"Para","c":[{"t":"Str","c":"bar"}]}]]
"""

/// Haskell Type: Block
/// Haskell Term:
/// Table
/// ("id", ["kls"], [("k1", "v1"), ("k2", "v2")])
/// (Caption
///  (Just [Str "short"])
///  [Para [Str "Demonstration"
///        ,Space
///        ,Str "of"
///        ,Space
///        ,Str "simple"
///        ,Space
///        ,Str "table"
///        ,Space
///        ,Str "syntax."]])
/// [(AlignDefault,ColWidthDefault)
/// ,(AlignRight,ColWidthDefault)
/// ,(AlignLeft,ColWidthDefault)
/// ,(AlignCenter,ColWidthDefault)
/// ,(AlignDefault,ColWidthDefault)]
/// (TableHead ("idh", ["klsh"], [("k1h", "v1h"), ("k2h", "v2h")])
///  [tRow
///   [tCell [Str "Head"]
///   ,tCell [Str "Right"]
///   ,tCell [Str "Left"]
///   ,tCell [Str "Center"]
///   ,tCell [Str "Default"]]])
/// [TableBody ("idb", ["klsb"], [("k1b", "v1b"), ("k2b", "v2b")]) 1
///  [tRow
///   [tCell [Str "ihead12"]
///   ,tCell [Str "i12"]
///   ,tCell [Str "i12"]
///   ,tCell [Str "i12"]
///   ,tCell [Str "i12"]]]
///  [tRow
///   [tCell [Str "head12"]
///   ,tCell' [Str "12"]
///   ,tCell [Str "12"]
///   ,tCell' [Str "12"]
///   ,tCell [Str "12"]]
/// ,tRow
///   [tCell [Str "head123"]
///   ,tCell [Str "123"]
///   ,tCell [Str "123"]
///   ,tCell [Str "123"]
///   ,tCell [Str "123"]]
/// ,tRow
///   [tCell [Str "head1"]
///   ,tCell [Str "1"]
///   ,tCell [Str "1"]
///   ,tCell [Str "1"]
///   ,tCell [Str "1"]]]]
/// (TableFoot ("idf", ["klsf"], [("k1f", "v1f"), ("k2f", "v2f")])
///  [tRow
///   [tCell [Str "foot"]
///   ,tCell [Str "footright"]
///   ,tCell [Str "footleft"]
///   ,tCell [Str "footcenter"]
///   ,tCell [Str "footdefault"]]])
/// where
///   tCell i = Cell ("a", ["b"], [("c", "d"), ("e", "f")]) AlignDefault 1 1 [Plain i]
///   tCell' i = Cell ("id", ["kls"], [("k1", "v1"), ("k2", "v2")]) AlignDefault 1 1 [Plain i]
///   tRow = Row ("id", ["kls"], [("k1", "v1"), ("k2", "v2")])
let table = """
{"t":"Table","c":[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[{"t":"Str","c":"short"}],[{"t":"Para","c":[{"t":"Str","c":"Demonstration"},{"t":"Space"},{"t":"Str","c":"of"},{"t":"Space"},{"t":"Str","c":"simple"},{"t":"Space"},{"t":"Str","c":"table"},{"t":"Space"},{"t":"Str","c":"syntax."}]}]],[[{"t":"AlignDefault"},{"t":"ColWidthDefault"}],[{"t":"AlignRight"},{"t":"ColWidthDefault"}],[{"t":"AlignLeft"},{"t":"ColWidthDefault"}],[{"t":"AlignCenter"},{"t":"ColWidthDefault"}],[{"t":"AlignDefault"},{"t":"ColWidthDefault"}]],[["idh",["klsh"],[["k1h","v1h"],["k2h","v2h"]]],[[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"Head"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"Right"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"Left"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"Center"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"Default"}]}]]]]]],[[["idb",["klsb"],[["k1b","v1b"],["k2b","v2b"]]],1,[[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"ihead12"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"i12"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"i12"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"i12"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"i12"}]}]]]]],[[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"head12"}]}]],[["id",["kls"],[["k1","v1"],["k2","v2"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"12"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"12"}]}]],[["id",["kls"],[["k1","v1"],["k2","v2"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"12"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"12"}]}]]]],[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"head123"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"123"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"123"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"123"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"123"}]}]]]],[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"head1"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"1"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"1"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"1"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"1"}]}]]]]]]],[["idf",["klsf"],[["k1f","v1f"],["k2f","v2f"]]],[[["id",["kls"],[["k1","v1"],["k2","v2"]]],[[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"foot"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"footright"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"footleft"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"footcenter"}]}]],[["a",["b"],[["c","d"],["e","f"]]],{"t":"AlignDefault"},1,1,[{"t":"Plain","c":[{"t":"Str","c":"footdefault"}]}]]]]]]]}
"""

/// Haskell Type: Block
/// Haskell Term:
/// Div ("id", ["kls"], [("k1", "v1"), ("k2", "v2")]) [Para [Str "Hello"]]
let div = """
{"t":"Div","c":[["id",["kls"],[["k1","v1"],["k2","v2"]]],[{"t":"Para","c":[{"t":"Str","c":"Hello"}]}]]}
"""

/// Haskell Type: Block
/// Haskell Term: / Null
let null = """
{"t":"Null"}
"""
