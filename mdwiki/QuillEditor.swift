//
//  QuillEditor.swift
//  mdwiki
//
//  Created by Devin Lehmacher on 3/13/21.
//

import SwiftUI
import WebKit
import utils

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
    
    @Binding var text: String
    
    private var loaded = false
    
    init(text: Binding<String>) {
        self._text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "textChanged")
        // TODO call user script and see that we get some result on the other side
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        return WKWebView(frame: .zero, configuration: config)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if !loaded {
            webView.loadHTMLString(helloWorldHtml, baseURL: URL(fileURLWithPath: "/"))
        }
        
        let updateColoring = """
        return true;
        """
        
        webView.callAsyncJavaScript(updateColoring, in: nil, in: .defaultClient, completionHandler: onDoneUpdatingColoring(result:))
    }
    
    func onDoneUpdatingColoring(result: Result<Any,Error>) {
        switch result {
        case .success(let x as Bool):
            print("Finished evaluating javascript with bool result \(x)")
        case .success(let x as Int):
            print("Finished evaluating javascript with int result \(x)")
        default:
            print("Finished evaluating javascript with error or other result")
        }
    }
}

class Coordinator: NSObject {
}

extension Coordinator : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let params = message.body as? NSDictionary else {
            log("couldn't parse params of message from javascript")
            return
        }
        
        switch message.name {
        case "textChanged":
            guard let delta: Delta = (params["delta"] as? NSDictionary)?.decode() else {
                log("couldn't parse delta")
                return
            }
            guard let oldContents: Delta = (params["oldContents"] as? NSDictionary)?.decode() else {
                log("couldn't parse oldContents")
                return
            }
            guard let source: Source = (params["source"] as? NSString)?.decode() else {
                log("couldn't parse source")
                return
            }
            textChanged(delta: delta, oldContents: oldContents, source: source)
        default:
            log("unsupported message type was received")
        }
    }
        
    private func textChanged(delta: Delta, oldContents: Delta, source: Source) {
        // TODO implement this method
    }
}

struct QuillEditor_Previews: PreviewProvider {
    static var previews: some View {
        QuillEditor(text: .constant("Hi"))
    }
}
