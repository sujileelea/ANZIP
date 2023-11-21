//
//  EntryPage.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI

struct EntryPage: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Background")
                    .resizable()
                VStack {
                    NavigationLink(destination: {
                        InputPage()
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
}

#Preview {
    EntryPage()
}
