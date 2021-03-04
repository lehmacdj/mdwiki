//
//  pandoc_types_tests.swift
//  pandoc-types-tests
//
//  Created by Devin Lehmacher on 2/10/21.
//

import XCTest
import utils
@testable import pandoc_types

class pandoc_types_tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func assertParses<T: Equatable & Decodable>(_ testData: (String, T)) throws {
        let (json, expected) = testData
        XCTAssertEqual(try json.unsafeDecode(), expected)
    }

    func test_testDataIsSameVersionAsLibrary() throws {
        XCTAssertEqual(pandocApiVersion, testDataPandocApiVersion)
    }

    // MARK: Pandoc

    func test_parsePandoc_empty() throws {
        try assertParses(emptyPandoc)
    }

    func test_parsePandoc_simpleContent() throws {
        try assertParses(simpleContentPandoc)
    }

    // MARK: Meta
    // TODO: add test cases from test data in TestData.swift

    // MARK: Inline + related types

    func test_parseQuoteType_singleQuote() throws {
        try assertParses(singlequote)
    }

    func test_parseQuoteType_doubleQuote() throws {
        try assertParses(doublequote)
    }

    func test_parseCitationMode_authorInText() throws {
        try assertParses(authorintext)
    }

    func test_parseCitationMode_suppressAuthor() throws {
        try assertParses(suppressauthor)
    }

    func test_parseCitationMode_normalCitation() throws {
        try assertParses(normalcitation)
    }

    func test_parseCitation() throws {
      try assertParses(citation)
    }

    func test_parseMathType_displayMath() throws {
      try assertParses(displaymath)
    }

    func test_parseMathType_inlineMath() throws {
      try assertParses(inlinemath)
    }

    func test_parseInline_str() throws {
        try assertParses(str)
    }

    func test_parseInline_emph() throws {
        try assertParses(emph)
    }

    func test_parseInline_underline() throws {
        try assertParses(underline)
    }

    func test_parseInline_strong() throws {
        try assertParses(strong)
    }

    func test_parseInline_strikeout() throws {
        try assertParses(strikeout)
    }

    func test_parseInline_superscript() throws {
        try assertParses(superscript)
    }

    func test_parseInline_subscript() throws {
        try assertParses(`subscript`)
    }

    func test_parseInline_smallcaps() throws {
        try assertParses(smallcaps)
    }

    func test_parseInline_cite() throws {
        try assertParses(cite)
    }

    func test_parseInline_code() throws {
        try assertParses(code)
    }

    func test_parseInline_space() throws {
        try assertParses(space)
    }

    func test_parseInline_softBreak() throws {
        try assertParses(softbreak)
    }

    func test_parseInline_rawInline() throws {
        try assertParses(rawinline)
    }

    func test_parseInline_link() throws {
        try assertParses(link)
    }

    func test_parseInline_image() throws {
        try assertParses(image)
    }

    func test_parseInline_note() throws {
        try assertParses(note)
    }

    func test_parseInline_span() throws {
        try assertParses(span)
    }

    // MARK: Block + related types
    // TODO: finish adding test cases from TestData.swift

    func test_parseBlock_plain() throws {
        try assertParses(plain)
    }
}
