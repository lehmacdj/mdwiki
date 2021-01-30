//
//  ContentView.swift
//  Haskell Example App
//
//  Created by Devin Lehmacher on 1/20/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(String(cString: hello()))
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
