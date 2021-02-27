//
//  StringExtensions.swift
//  utils
//
//  Created by Devin Lehmacher on 2/10/21.
//

import Foundation

public extension String {
    func decode<T>() -> T? where T : Decodable {
        let decoder = JSONDecoder()
        guard let data = self.data(using: .utf8) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
    
    func unsafeDecode<T>() throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        let data = self.data(using: .utf8)!
        return try decoder.decode(T.self, from: data)
    }

}
