//
//  Commonmark.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 2/10/21.
//

import Foundation

func toPandocAstString(markdown input: String) -> String {
    return input.utf8CString.withUnsafeBufferPointer { ptr in
        return String(
            cString: try_parse_commonmark_json_api(
                UnsafeMutablePointer(mutating: ptr.baseAddress)))
    }
}
