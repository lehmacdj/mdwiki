# mdwiki

An iOS app for editing Zettelkasten like sets of markdown notes. Intended for my
use as companion to https://neuron.zettel.page.

Currently in very early development and not really functional.

## Building
Build the two subprojects; then build in Xcode.

### markdown-engine
First you will need to setup a Haskell cross compiler toolchain (no instructions
for doing this for now); and put the tools in the paths specified by `call`
executable or modify `call` to point to your toolchain.

Then just run `./call make iOS` from the "markdown-engine" directory.

### editor-ui
Run `npm install && npm run bundle` from the "editor-ui" directory.
