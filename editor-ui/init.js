//
//  init.js
//  mdwiki
//
//  Created by Devin Lehmacher on 4/8/21.
//

window.webkit.messageHandlers.textChanged.postMessage({
  delta: { ops: [] },
  oldContents: { ops: [] },
  source: 'user'
})

const Quill = require('./quill.js')

const quill = new Quill('#editor', {
  theme: 'snow'
})

console.log(quill)
