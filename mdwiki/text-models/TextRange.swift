//
//  TextRange.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 4/13/21.
//

import Foundation

struct TextRange: Equatable, Decodable, Encodable {
    let index: Int
    let length: Int
}
