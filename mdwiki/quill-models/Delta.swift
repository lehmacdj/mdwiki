//
//  Delta.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 4/7/21.
//

import Foundation

/// Represents a Delta: https://quilljs.com/docs/delta/
public struct Delta: Decodable, Equatable {
    let ops:  [Op]
}

enum AttributeValue: Equatable {
    case bool(Bool)
    case string(String)
}

extension AttributeValue: Decodable {
    init(from decoder: Decoder) throws {
        if let bool = try? Bool(from: decoder) {
            self = .bool(bool)
        } else if let string = try? String(from: decoder) {
            self = .string(string)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "badly formed AttributeValue"))
        }
    }
}

struct Op: Equatable {
    let kind: OpKind
    let attributes: [String:AttributeValue]
    
    init(kind: OpKind, attributes: [String:AttributeValue] = [:]) {
        self.kind = kind
        self.attributes = attributes
    }
}

enum OpKind: Equatable {
    case insert(String)
    case delete(Int)
    case retain(Int)
}

extension Op: Decodable {
    enum CodingKeys: String, CodingKey {
        case insert
        case delete
        case retain
        case attributes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let insertVal = try container.decodeIfPresent(String.self, forKey: .insert)
        let deleteVal = try container.decodeIfPresent(Int.self, forKey: .delete)
        let retainVal = try container.decodeIfPresent(Int.self, forKey: .retain)
        switch (insertVal, deleteVal, retainVal) {
        case (.some(let insertVal), nil, nil):
            self.kind = .insert(insertVal)
        case (nil, .some(let deleteVal), nil):
            self.kind = .delete(deleteVal)
        case (nil, nil, .some(let retainVal)):
            self.kind = .retain(retainVal)
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "badly formed Delta.Op"))
        }
        
        self.attributes = try container.decodeIfPresent([String:AttributeValue].self, forKey: .attributes) ?? [:]
    }
}
