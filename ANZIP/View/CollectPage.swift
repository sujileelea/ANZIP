//
//  CollectPage.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI

struct CollectPage: View {
    
    @State var review: Review = Review()
    @State var isPostingData = false

    @State var selectedScore: Int = 0
    @State var content: String = ""
    
    @Binding var showEvaluationSheet: Bool

    var body: some View {
        VStack(alignment: .leading) {
            //헤더
            VStack(alignment: .leading, spacing: 4) {
                Text("분석 결과는 어떠셨나요?")
                    .font(.system(size: 25, weight: .bold))
                VStack(alignment: .leading) {
                    Text("도움이 된만큼 별점을 매겨주세요 ")
                }
                .font(.system(size: 17))
            }
            .padding(.bottom, 40)
            .padding(.leading, 10)
            //별
            HStack(spacing: -5) {
                ForEach(0..<5) { index in
                    Button(action: {
                        withAnimation(.easeInOut(duration: -1)) {
                            selectedScore = index + 1
                        }
                    }, label: {
                        Image(systemName: index < selectedScore ?? 0 ? "star.fill" : "star")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32)
                            .foregroundColor(.yellow)
                    })
                    .padding(.leading)
                }
            }
            //코멘트
            VStack(spacing: 2) {
                //글자수
                HStack() {
                    if content.count == 0 {
                        Text("1~200자로 입력해주세요")
                            .font(.system(size: 13))
                            .foregroundColor(.hex7E7E7E)
                    }
                    Spacer()
                    Text("\(content.count)/200")
                        .font(.system(size: 14))
                        .foregroundColor(content.count > 200 ? .red : .hex7E7E7E)
                }
                //입력창
                TextEditor(text: $content)
                    .frame(width: screenWidth * 0.85, height: 170)
                    .padding(5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.hex7E7E7E, lineWidth: 0.5)
                    }
                //경고 메세지
                HStack {
                    Spacer()
                    Text(content.trimmingCharacters(in: .whitespaces) == "" ? "공백만으로 이루어질 수 없습니다" : "")
                    Text(content.count > 200 ? "200자를 초과할 수 없습니다" : "")
                }
                .font(.system(size: 12))
                .foregroundColor(.hex7E7E7E)
            }
            .frame(width: screenWidth * 0.85)
            .padding()
        }
        .padding()
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    showEvaluationSheet = false
                }, label: {
                    Text("취소")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.blue)
                })
            })
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                    Text("완료")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.blue)
            })
        })
    }
    
    func postDataFromServer() {
            // 비동기적으로 데이터를 가져오는 중임을 표시
            isPostingData = true
        
           // 실제 서버 URL을 사용하려면 여기에 해당 URL을 입력하세요.
           let serverURL = URL(string: "https://example.com/api")!

           // POST 요청을 위한 URLRequest 생성
           var request = URLRequest(url: serverURL)
           request.httpMethod = "POST"

           // JSON 데이터를 생성하여 요청 바디에 추가
            do {
                let jsonData = try JSONEncoder().encode(review)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
            }

           // 서버로 요청을 보내고 응답 처리
           URLSession.shared.dataTask(with: request) { data, response, error in
               if let data = data {
                   print("데이터 수집 완ㄹ")
               } else if let error = error {
                   print("Error sending POST request: \(error)")
               }
           }.resume()
       }

}

#Preview {
    CollectPage(showEvaluationSheet: .constant(true))
}
