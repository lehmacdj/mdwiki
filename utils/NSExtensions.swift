//
//  AnyExtensions.swift
//  utils
//
//  Created by Devin Lehmacher on 4/7/21.
//

import Foundation

public extension NSDictionary {
    func decode<T : Decodable>() -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}

public extension NSArray {
    func decode<T : Decodable>() -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
