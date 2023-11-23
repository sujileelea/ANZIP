//
//  ContentView.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI

var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height


enum PageIndex {
    case entryPage
    case inputPage
    case outputPage
}

struct ContentView: View {
    
    @State var pageIndex: PageIndex = .entryPage
    
    @State var inputData: Input = Input()
    @State var outputData: Output = Output()

    var body: some View {
        VStack {
            switch pageIndex {
            case .entryPage:
                EntryPage(pageIndex: $pageIndex)
            case .inputPage:
                InputPage(pageIndex: $pageIndex, inputData: $inputData, outputData: $outputData)
            case .outputPage:
                OutputPage(pageIndex: $pageIndex, inputData: $inputData, outputData: $outputData)
            }
        }
    }
}

#Preview {
    ContentView()
}
