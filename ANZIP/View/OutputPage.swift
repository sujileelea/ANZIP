//
//  OutputPage.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI


struct OutputPage: View {

    @Binding var info: Info?
    
    @Binding var selectedDayString: String
    @Binding var selectedTimeString: String
    @Binding var selectedSubwayStop: String
    
    @State var status: String = "Good"
    @State var showEvaluationSheet: Bool = false
    
    var body: some View {
        VStack {
            //헤더
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    KoreanDayOfWeek(day: selectedDayString)
                    Text(selectedTimeString)
                }
                .font(.system(size: 21, weight: .bold))
                VStack(alignment: .leading) {
                    Text(selectedSubwayStop + "출발 🚃")
                }
                .font(.system(size: 19))
                .padding(.top, 10)
            }
            // 자리 지킴이
            VStack(spacing: -2) {
                Image(status)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                ZStack {
                    Image("Balloon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .offset(x: -5)
                        .padding(.bottom, 6)
                    VStack {
                        if status == "Good" {
                            Text("앉을 확률 높아요!")
                        } else if status == "Soso" {
                            Text("적당히 붐비네요!")
                        } else if status == "Bad" {
                            Text("앉을 확률 낮아요!")
                        }
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .offset(x: -8, y: 2)
                }
            }
            VStack {
                TagMessage(status: status)
            }
            .padding(.bottom, 30)
            // 그래프
            VStack {
                GraphView()
            }
            .padding(.bottom, 10)
            // 평가 버튼
            Button(action: {
                showEvaluationSheet = true
            }, label: {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.hexFFA800)
                    .frame(width: screenWidth * 0.7, height: 50)
                    .overlay (
                        Text("결과 평가하기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    )
            })
        }
        .sheet(isPresented: $showEvaluationSheet, content: {
            CollectPage(showEvaluationSheet: $showEvaluationSheet)
        })
    }
    
    @ViewBuilder
    func KoreanDayOfWeek(day: String) -> some View {
        if day == "MON" {
            Text("월요일")
        } else if day == "TUE" {
            Text("화요일")
        } else if day == "WED" {
            Text("수요일")
        } else if day == "THU" {
            Text("목요일")
        } else if day == "FRI" {
            Text("금요일")
        } else if day == "SAT" {
            Text("토요일")
        } else if day == "SUN" {
            Text("일요일")
        }
    }
    
    @ViewBuilder
    func TagMessage(status: String) -> some View {
        VStack {
            if status == "Good" {
                Text("""
                    # 자리 골라앉기
                    # 창밖 구경
                    # 집은 이 시간에
                """)
            } else if status == "Soso" {
                Text("""
                     # 호다닥 조심조심
                     # 궁둥이 들이밀기
                     # 매너있게 들이밀기
                """)
            } else if status == "Bad" {
                Text("""
                # 이 시간은 피해요
                # 가방 앞으로 매기
                # 조금만 참아요
                """)
            }
        }
        .multilineTextAlignment(.center)
        .font(.system(size: 16, weight: .semibold))
    }
}
