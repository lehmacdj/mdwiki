//
//  ContentView.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 1/20/21.
//

import SwiftUI

let markdown = """
---
title: I am a title
---

# Heading
Some *emphasized* text.
"""

let shortMarkdown = """
Hi
"""


struct ContentView: View {
    @State var text: String = shortMarkdown
    var body: some View {
        VStack {
            QuillEditor(text: $text)
            TextEditor(text: $text)
            if let pandoc = toPandocAst(markdown: text) {
                TextEditor(text: .constant(String(reflecting: pandoc)))
            } else {
                Text("Failed to compile markdown!")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
