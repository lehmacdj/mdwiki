//
//  Pandoc.swift
//  pandoc-types
//
//  Created by Devin Lehmacher on 2/10/21.
//

import Foundation

public let pandocApiVersion = [1, 22]

public struct Pandoc: Equatable {
    let meta: [String:MetaValue]
    let blocks: [Block]
}

extension Pandoc: Decodable {
    public init(from decoder: Decoder) throws {
        let prePandoc = try PrePandoc(from: decoder)
        guard prePandoc.pandocApiVersion == pandocApiVersion else {
            throw DecodingError.dataCorruptedError(
                for: decoder.codingPath,
                debugDescription: "api version (\(prePandoc.pandocApiVersion)) doesn't match the api version of this library (\(pandocApiVersion))")
        }
        meta = prePandoc.meta
        blocks = prePandoc.blocks
    }
}

public enum MetaValue: Equatable {}

extension MetaValue: Decodable {
    public init(from decoder: Decoder) {
        fatalError("unimplemented")
    }
}

private struct AesonPair<A, B>: Decodable where A: Decodable, B: Decodable {
    let fst: A
    let snd: B
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        fst = try container.decode(A.self)
        snd = try container.decode(B.self)
        if !container.isAtEnd {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "too many elements for AesonPair")
        }
    }
    
    func pair() -> (A, B) {
        return (fst, snd)
    }
}

public struct Attr: Equatable {
    let identifier: String
    let classes: [String]
    let kvPairs: [String:String]
}

extension Attr: Decodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        identifier = try container.decode(String.self)
        classes = try container.decode([String].self)
        let pairs = try container.decode([AesonPair<String, String>].self)
        kvPairs = Dictionary(pairs.map({ $0.pair() }), uniquingKeysWith: {x, y in x})
    }
}

public struct ListAttributes: Equatable {}

public struct Caption: Equatable {}

public enum TableAlignment: Equatable {}

public struct TableContent: Equatable {}

public struct Definition: Equatable {
    let term: [Inline]
    let definition: [[Block]]
}

public struct TableAlignmentSpec: Equatable {
    let alignment: TableAlignment
    /// Width as a fraction of the whole 1. If nil uses default width.
    let width: Float?
}

public struct Table: Equatable {
    let attr: Attr
    let caption: Caption
    let alignments: [TableAlignmentSpec]
    let head: TableContent
    let body: [TableContent]
    let foot: TableContent
}

public enum Block: Equatable {
    case plain([Inline])
    case para([Inline])
    case lineBlock([[Inline]])
    case codeBlock(Attr, String)
    case rawBlock(format: String, String)
    case blockQuote([Block])
    case orderedList(ListAttributes, [[Block]])
    case bulletList([[Block]])
    case definitionList([Definition])
    case header(Int, Attr, [Inline])
    case horizontalRule
    // case table(Table)
    case div(Attr, [Block])
    case null
}

private enum AesonNodeKeys: String, CodingKey {
    case t = "t"
    case c = "c"
}

private enum AesonTypeOnlyKeys: String, CodingKey {
    case t = "t"
}

private extension UnkeyedDecodingContainer {
    mutating func decodeAll<T: Decodable>() throws -> [T] {
        var result = [T]()
        while !self.isAtEnd {
            result.append(try self.decode(T.self))
        }
        return result
    }
    
}

extension Block: Decodable {
    public init(from decoder: Decoder) throws {
        guard let aeson = try? decoder.container(keyedBy: AesonNodeKeys.self) else {
            throw DecodingError.dataCorruptedError(for: decoder.codingPath, debugDescription: "Couldn't parse block missing keys t or c")
        }

        let type = try aeson.decode(String.self, forKey: .t)
        
        switch type {
        case "Div":
            var container = try aeson.nestedUnkeyedContainer(forKey: .c)
            let attr = try container.decode(Attr.self)
            let children = try container.decode([Block].self)
            self = .div(attr, children)
        case "Para":
            self = .para(try aeson.decode([Inline].self, forKey: .c))
        default:
            fatalError("unimplemented")
        }
    }
}

public enum Inline: Equatable {
    case str(String)
    case emph([Inline])
    case underline([Inline])
    case strong([Inline])
    case strikeout([Inline])
    case `subscript`([Inline])
    case superscript([Inline])
    case smallCaps([Inline])
    case quoted(QuoteType, [Inline])
    case cite([Citation], [Inline])
    case code(Attr, String)
    case space
    case softBreak
    case lineBreak
    case math(MathType, String)
    case rawInline(format: String, String)
    case link(Attr, [Inline], url: String, title: String)
    case image(Attr, [Inline], url: String, title: String)
    case note([Block])
    case span(Attr, [Inline])
}

extension DecodingError {
    /// Helper that returns a generic decoding error given a codingPath and a detailed description.
    /// Do try to use one of the more specific overloads first if you want to use this though.
    static func dataCorruptedError(for codingPath: [CodingKey], debugDescription: String) -> DecodingError {
        return DecodingError.dataCorrupted(Context(codingPath: codingPath, debugDescription: debugDescription))
    }
}

extension Inline: Decodable {
    public init(from decoder: Decoder) throws {
        guard let aeson = try? decoder.container(keyedBy: AesonNodeKeys.self) else {
            throw DecodingError.dataCorruptedError(for: decoder.codingPath, debugDescription: "Couldn't parse block missing keys t or c")
        }
        
        let type = try aeson.decode(String.self, forKey: .t)
        
        switch type {
        case "Span":
            var container = try aeson.nestedUnkeyedContainer(forKey: .c)
            let attr = try container.decode(Attr.self)
            let children = try container.decode([Inline].self)
            self = .span(attr, children)
        case "Emph":
            let children = try aeson.decode([Inline].self, forKey: .c)
            self = .emph(children)
        case "Str":
            self = .str(try aeson.decode(String.self, forKey: .c))
        case "Underline":
            self = .underline(try aeson.decode([Inline].self, forKey: .c))
        default:
            fatalError("unimplemented")
        }
    }
}

public enum QuoteType: Equatable {
    case singleQuote
    case doubleQuote
}

extension QuoteType: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AesonTypeOnlyKeys.self)
        let t = try container.decode(String.self, forKey: .t)
        switch t {
        case "SingleQuote":
            self = .singleQuote
        case "DoubleQuote":
            self = .doubleQuote
        default:
            throw DecodingError.dataCorruptedError(forKey: .t, in: container, debugDescription: "failed to parse QuoteType")
        }
    }
}

public enum CitationMode {
    case authorInText
    case suppressAuthor
    case normalCitation
}

extension CitationMode: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AesonTypeOnlyKeys.self)
        let t = try container.decode(String.self, forKey: .t)
        switch t {
        case "AuthorInText":
            self = .authorInText
        case "SuppressAuthor":
            self = .suppressAuthor
        case "NormalCitation":
            self = .normalCitation
        default:
            throw DecodingError.dataCorruptedError(forKey: .t, in: container, debugDescription: "failed to parse CitationMode")
        }
    }
}

public struct Citation: Decodable, Equatable {
    let id: String
    let prefix: [Inline]
    let suffix: [Inline]
    let mode: CitationMode
    let noteNum: Int
    let hash: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "citationId"
        case prefix = "citationPrefix"
        case suffix = "citationSuffix"
        case mode = "citationMode"
        case noteNum = "citationNoteNum"
        case hash = "citationHash"
    }
}

public enum MathType: Equatable {
    case displayMath
    case inlineMath
}

extension MathType: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AesonTypeOnlyKeys.self)
        let t = try container.decode(String.self, forKey: .t)
        switch t {
        case "DisplayMath":
            self = .displayMath
        case "InlineMath":
            self = .inlineMath
        default:
            throw DecodingError.dataCorruptedError(forKey: .t, in: container, debugDescription: "failed to parse MathType")
        }
    }
}

/// Represents a pandoc document that hasn't been fully converted into a swift data structure yet.
public struct PrePandoc: Decodable, Equatable {
    public let pandocApiVersion: [Int]
    public let meta: [String:MetaValue]
    public let blocks: [Block]
    
    private enum CodingKeys: String, CodingKey {
        case pandocApiVersion = "pandoc-api-version"
        case meta
        case blocks
    }
}
