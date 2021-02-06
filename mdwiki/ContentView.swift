//
//  ContentView.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 1/20/21.
//

import SwiftUI

let markdown = "#Heading\nBody. *Emphasis*.".utf8CString

struct ContentView: View {
    var body: some View {
        Text(
            String(cString: markdown.withUnsafeBufferPointer({ ptr in try_parse_commonmark_json_api(UnsafeMutablePointer(mutating: ptr.baseAddress))})))
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
