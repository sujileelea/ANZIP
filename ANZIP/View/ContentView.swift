//
//  ContentView.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI

var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    var body: some View {
        VStack {
            EntryPage()
        }
    }
}

#Preview {
    ContentView()
}
