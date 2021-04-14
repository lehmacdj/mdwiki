//
//  mdwikiTests.swift
//  mdwikiTests
//
//  Created by Devin Lehmacher on 4/11/21.
//

import XCTest
import Nimble
import utils
@testable import mdwiki

class mdwikiTests: XCTestCase {
    func test_simpleDeltaParses() throws {
        let json = """
        {"ops":[{"retain":1},{"delete":1}]}
        """
        let actual: Delta = json.decode()!
        let expected = Delta(ops: [
            Op(kind: .retain(1)),
            Op(kind: .delete(1))
        ])
        XCTAssertEqual(actual, expected)
    }
    
    func test_deltaWithAttributes() throws {
        let json = """
        {
          "ops": [
            { "insert":"Hello world! " },
            {
              "attributes": {"bold":true},
              "insert":"bold"
            },
            {"insert":" Hi!"}
          ]
        }
        """
        let actual: Delta = json.decode()!
        let expected = Delta(ops: [
            Op(kind: .insert("Hello world! ")),
            Op(kind: .insert("bold"), attributes: ["bold":.bool(true)]),
            Op(kind: .insert(" Hi!"))
        ])
        XCTAssertEqual(actual, expected)
    }
    
    func test_textRangeDecode() throws {
        let json = """
        {
            "index": 42,
            "length": 91
        }
        """
        let actual: TextRange = json.decode()!
        let expected = TextRange(index: 42, length: 91)
        XCTAssertEqual(actual, expected)
    }
    
    func test_logLevels_orderedByUrgency() throws {
        expect(LogLevel.verbose) < LogLevel.info
        expect(LogLevel.info) < LogLevel.warning
        expect(LogLevel.warning) < LogLevel.error
    }
}
