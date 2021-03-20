//
//  QuillEditor.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 3/13/21.
//

import SwiftUI
import WebKit

let helloWorldHtml = """
<!-- Include stylesheet -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">

<!-- Create the editor container -->
<div id="editor">
  <p>Hello World!</p>
  <p>Some initial <strong>bold</strong> text</p>
  <p><br></p>
</div>

<!-- Include the Quill library -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>

<!-- Initialize Quill editor -->
<script>
  var quill = new Quill('#editor', {
    theme: 'snow'
  });
</script>
"""

struct QuillEditor: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(helloWorldHtml, baseURL: URL(fileURLWithPath: "/"))
    }
}

struct QuillEditor_Previews: PreviewProvider {
    static var previews: some View {
        QuillEditor()
    }
}
