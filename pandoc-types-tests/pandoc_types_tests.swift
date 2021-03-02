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
    
    func test_testDataIsSameVersionAsLibrary() throws {
        XCTAssertEqual(pandocApiVersion, testDataPandocApiVersion)
    }
    
    func assertParses<T: Equatable & Decodable>(_ testData: (String, T)) throws {
        let (json, expected) = testData
        XCTAssertEqual(try json.unsafeDecode(), expected)
    }
    
    func test_parsePandoc_empty() throws {
        try assertParses(emptyPandoc)
    }
    
    func test_parsePandoc_simpleContent() throws {
        try assertParses(simpleContentPandoc)
    }
    
    func test_parseInline_emph() throws {
        try assertParses(emph)
    }
    
    func test_parseInline_str() throws {
        try assertParses(str)
    }
    
    func test_parseInline_underline() throws {
        try assertParses(underline)
    }

}
