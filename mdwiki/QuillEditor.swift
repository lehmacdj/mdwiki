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
    
    private var editorUiScript: String {
        guard let filepath = Bundle.main.path(forResource: "editor-ui", ofType: "js") else {
            log("file editor-ui.js not present in bundle, returning empty contents for script")
            return ""
        }
        do {
            return try String(contentsOfFile: filepath)
        } catch {
            log("unable to read editor-ui.js, returning empty contents for script")
            return ""
        }
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "textChanged")
        contentController.add(context.coordinator, name: "log")
        contentController.addUserScript(WKUserScript(source: editorUiScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        return WKWebView(frame: .zero, configuration: config)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if !loaded {
            webView.loadHTMLString(helloWorldHtml, baseURL: URL(fileURLWithPath: "/"))
        }

//        let updateColoring = """
//        return true;
//        """
//
//        webView.callAsyncJavaScript(updateColoring, in: nil, in: .defaultClient, completionHandler: onDoneUpdatingColoring(result:))
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
        log("received message: \(message.name)", level: .verbose)
        
        guard let params = message.body as? NSDictionary else {
            log("couldn't parse params of message from javascript")
            return
        }
        
        log("params for message are: \(params)", level: .verbose)
        
        switch message.name {
        case "textChanged":
            guard let delta: Delta = (params["delta"] as? NSDictionary)?.decode() else {
                warn("couldn't parse delta")
                return
            }
            guard let oldContents: Delta = (params["oldContents"] as? NSDictionary)?.decode() else {
                warn("couldn't parse oldContents")
                return
            }
            guard let source = params["source"] as? NSString else {
                warn("couldn't parse source")
                return
            }
            textChanged(delta: delta, oldContents: oldContents, source: Source(from: source))
        case "log":
            guard let message = params["message"] as? NSString else {
                warn("couldn't parse message")
                return
            }
            let level: LogLevel
            if let levelNumber = params["level"] as? Int {
                if let levelOverride = LogLevel(rawValue: levelNumber) {
                    level = levelOverride
                } else {
                    warn("invalid Int passed as level")
                    level = .info
                }
            } else {
                warn("bad value for level")
                level = .info
            }
            log(String(message), level: level, callingFunction: "<javascript>")
        default:
            warn("unsupported message type was received")
        }
    }
        
    private func textChanged(delta: Delta, oldContents: Delta, source: Source) {
        // TODO implement this method
        log("receive textChanged event")
    }
}

struct QuillEditor_Previews: PreviewProvider {
    static var previews: some View {
        QuillEditor(text: .constant("Hi"))
    }
}
