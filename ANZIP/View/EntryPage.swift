//
//  EntryPage.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI

struct EntryPage: View {
    
    @Binding var pageIndex: PageIndex
    
    var body: some View {
            ZStack {
                Image("Background")
                    .resizable()
                VStack {
                    Button(action: {
                        pageIndex = .inputPage
                    }, label: {
                        HStack {
                            Text("입장하기")
                            Image(systemName: "arrow.right")
                        }
                        .foregroundStyle(Color.white)
                        .font(.system(size: 22, weight: .semibold))
                    })
                }
                .padding(.top, 180)
                .padding(.leading, 180)
            }
            .ignoresSafeArea()
    }
}
