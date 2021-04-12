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
    case api
    case other
    
    init(from string: String) {
        switch string {
        case "user":
            self = .user
        case "api":
            self = .api
        default:
            self = .other
        }
    }
    
    init(from nsstring: NSString) {
        self.init(from: String(nsstring))
    }
}

extension Source: Decodable {
    init(from decoder: Decoder) throws {
        switch try String(from: decoder) {
        case "user":
            self = .user
        default:
            self = .other
        }
    }
}
