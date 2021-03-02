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
    
    func test_parsePandoc_empty() throws {
        let pandoc: Pandoc = try emptyPandocJson.unsafeDecode()
        XCTAssertEqual(Pandoc(meta: [:], blocks: []), pandoc)
    }
    
    func test_parsePandoc_simpleContent() throws {
        let actual: Pandoc = try simpleContentPandocJson.unsafeDecode()
        let expected = Pandoc(
            meta: [:],
            blocks: [
                .div(
                    Attr(identifier: "", classes: [], kvPairs: ["data-pos":"source@1:1-2:1"]),
                    [
                        .para([
                            .span(
                                Attr(identifier: "", classes: [], kvPairs: ["data-pos":"source@1:1-1:3"]),
                                [
                                    .str("Hi")])])])])
                            
        XCTAssertEqual(expected, actual)
    }

}
