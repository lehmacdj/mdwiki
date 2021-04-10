//
//  Utils.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 4/7/21.
//

import Foundation

/// Log level to use when logging traces via log function
let logLevel = LogLevel.verbose

/// Logging function to be abstracted out into a real logging framework later if that seems worth it
func log(_ message : String, level: LogLevel = .info, _ callingFunction: String = #function) {
    if level >= logLevel {
        print("[\(Date())][\(callingFunction)][\(level)]: \(message)")
    }
}

enum LogLevel: Equatable, Comparable {
    case verbose
    case info
    case warning
    case error
}
