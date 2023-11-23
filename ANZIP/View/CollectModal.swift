//
//  CollectPage.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI

struct CollectModal: View {
    
    @State var review: Review = Review()
    @State var isPostingData = false

    @State var selectedScore: Int = 0
    @State var comments: String = ""
    
    @Binding var showEvaluationSheet: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                //헤더
                VStack(alignment: .leading, spacing: 4) {
                    Text("분석 결과는 어떠셨나요?")
                        .font(.system(size: 25, weight: .bold))
                    VStack(alignment: .leading) {
                        Text("도움이 된만큼 별점을 매겨주세요")
                    }
                    .font(.system(size: 17))
                }
                .padding(.bottom, 30)
                .padding(.leading, 10)
                //별
                HStack(spacing: -5) {
                    
                    ForEach(0..<5) { index in
                        Button(action: {
                            withAnimation(.easeInOut(duration: -1)) {
                                selectedScore = index + 1
                            }
                        }, label: {
                            Image(systemName: index < selectedScore ? "star.fill" : "star")
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
                        if comments.count == 0 {
                            Text("향상된 서비스를 위해 코멘트를 남겨주세요!")
                                .font(.system(size: 13))
                                .foregroundColor(.hex7E7E7E)
                        }
                        Spacer()
                        Text("\(comments.count)/100")
                            .font(.system(size: 14))
                            .foregroundColor(comments.count > 100 ? .red : .hex7E7E7E)
                    }
                    //입력창
                    TextEditor(text: $comments)
                        .frame(width: screenWidth * 0.85, height: 170)
                        .padding(5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.hex7E7E7E, lineWidth: 0.5)
                        }
                    //경고 메세지
                    HStack {
                        Spacer()
                        Text(comments.trimmingCharacters(in: .whitespaces) == "" ? "공백만으로 이루어질 수 없습니다" : "")
                            .foregroundStyle(Color.hex7E7E7E)
                        Text(comments.count > 100 ? "100자를 초과할 수 없습니다" : "")
                            .foregroundColor(.red)
                    }
                    .font(.system(size: 13))
                }
                .frame(width: screenWidth * 0.85)
                .padding()
            }
            .padding()
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        showEvaluationSheet = false
                    }, label: {
                        Text("취소")
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle(Color.hex7E7E7E)
                    })
                })
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        review.score = selectedScore
                        review.comment = comments
                        postDataToServer(reviewToPost: review)
                    }, label: {
                        Text("저장")
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle((selectedScore == 0 || comments.count > 200) ? .hex7E7E7E : .hex72A074)
                    })
                    .disabled( selectedScore == 0 || comments.count > 100)
                })
            })
        }
    }
    
    func postDataToServer(reviewToPost: Review) {
            print("송신할 리뷰 데이터 : ", reviewToPost)
            // 비동기적으로 데이터를 가져오는 중임을 표시
            isPostingData = true
        
           // 실제 서버 URL을 사용하려면 여기에 해당 URL을 입력하세요.
           let serverURL = URL(string: "https://anzip-api-davidlee.koyeb.app/comments")!

           // POST 요청을 위한 URLRequest 생성
           var request = URLRequest(url: serverURL)
           request.httpMethod = "POST"

           // JSON 데이터를 생성하여 요청 바디에 추가
            do {
                let jsonData = try JSONEncoder().encode(reviewToPost)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
            }

           // 서버로 요청을 보내고 응답 처리
           URLSession.shared.dataTask(with: request) { data, response, error in
               if let data = data {
                   showEvaluationSheet = false
                   print("응답 데이터 : ", data)
               } else if let error = error {
                   print("Error sending POST request: \(error)")
               }
           }.resume()
       }

}
