//
//  Utils.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 4/7/21.
//

import Foundation

/// Logging function to be abstracted out into a real logging framework later if that seems worth it
func log(_ message : String, _ callingFunction: String = #function) {
    print("\(callingFunction): \(message)")
}
