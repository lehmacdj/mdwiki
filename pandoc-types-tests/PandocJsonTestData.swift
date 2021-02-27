//
//  PandocJsonTestData.swift
//  pandoc-types-tests
//
//  Created by Devin Lehmacher on 2/18/21.
//

import Foundation

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

