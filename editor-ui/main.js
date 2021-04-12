//
//  init.js
//  mdwiki
//
//  Created by Devin Lehmacher on 4/8/21.
//

import Quill from 'quill'

function textChanged (delta, oldContents, source) {
  window.webkit.messageHandlers.textChanged.postMessage({
    delta: delta,
    oldContents: oldContents,
    source: source
  })
}

const LogLevel = {
  Error: 1,
  Warning: 2,
  Info: 3,
  Verbose: 4
}

function log (message, level) {
  level = level || LogLevel.Info
  window.webkit.messageHandlers.log.postMessage({
    message: message,
    level: level
  })
}

const quill = new Quill('#editor', {
  theme: 'snow'
})

quill.on('text-change', textChanged)

log('finished initializing quill editor successfully')
