//
//  CustomPregressView.swift
//  ANZIP
//
//  Created by Suji Lee on 11/23/23.
//

import SwiftUI

struct CustomProgressView: View {
    
    @State private var isAnimating = false

     var body: some View {
         VStack(spacing: 70) {
             Text("자리 지킴이 일하는중 💪")
                 .foregroundStyle(Color.black)
                 .font(.system(size: 30, weight: .black))
             Circle()
                 .trim(from: 0.2, to: 1)
                 .stroke(Color.hexFFA800, lineWidth: 10)
                 .frame(width: 150)
                 .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                 .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                 .onAppear() {
                     self.isAnimating.toggle()
                 }
         }
         .frame(width: screenWidth, height: screenHeight)
         .background(Color.white.opacity(0.8))
     }
}

#Preview {
    CustomProgressView()
}
