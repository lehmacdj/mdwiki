//
//  Source.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 4/7/21.
//

import Foundation

/// A source for an event received from a quill event handler
enum Source {
    case user
    case other
}

extension Source: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "user":
            self = .user
        default:
            self = .other
        }
    }
}
