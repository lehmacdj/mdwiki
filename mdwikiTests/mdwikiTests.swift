//
//  mdwikiTests.swift
//  mdwikiTests
//
//  Created by Devin Lehmacher on 4/11/21.
//

import XCTest
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
}
