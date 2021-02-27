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
    @State var text: String = markdown
    var body: some View {
        VStack {
            TextEditor(text: $text)
            Text(toPandocAstString(markdown: text))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
