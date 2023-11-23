//
//  OutputPage.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI


struct OutputPage: View {
    
    @Binding var pageIndex: PageIndex

    @Binding var inputData: Input
    @Binding var outputData: Output
    
    @State var showEvaluationSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                //헤더
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            HStack(spacing: 1) {
                                Text(inputData.month?.codingKey.stringValue ?? "")
                                    .font(.system(size: 28, weight: .bold))
                                Text("월")
                            }
                            .foregroundStyle(Color.hexFFA800)
                            KoreanDayOfWeek(day: inputData.day ?? "")
                            Text(inputData.time ?? "")
                        }
                        .font(.system(size: 25, weight: .bold))
                        HStack(spacing: 1) {
                            Text(inputData.subwayStop ?? "")
                            Text("출발 🚃")
                        }
                        .font(.system(size: 22))
                    }
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.bottom, 25)
                // 자리 지킴이
                VStack(spacing: -10) {
                    if let status = outputData.status {
                        Image(status)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110)
                    }
                    ZStack {
                        Image("Balloon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .padding(.bottom, 6)
                        VStack {
                            if outputData.status == "good" {
                                Text("앉을 확률 높아요!")
                            } else if outputData.status == "soso" {
                                Text("적당히 붐비네요!")
                            } else if outputData.status == "bad" {
                                Text("앉을 확률 낮아요!")
                            }
                        }
                        .offset(x: 10, y: 1)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                    }
                }
                VStack {
                    TagMessage(status: outputData.status ?? "")
                        .padding(.bottom, 40)
                        .padding(.leading, -5)
                }
                // 그래프
                VStack {
                    let outputDataArray: [(String, Int)] = outputData.data?.map { ($0.startTime, $0.score) } ?? []
                    GraphView(targetTime: inputData.time ?? "", data: outputDataArray)
                }
                .padding(.vertical, 10)
                // 평가 버튼
                Button(action: {
                    showEvaluationSheet = true
                }, label: {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.hexFFA800)
                        .frame(width: screenWidth * 0.86, height: 50)
                        .overlay (
                            Text("결과 평가하기")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        )
                })
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        pageIndex = .inputPage
                    }, label: {
                        Text("뒤로 가기")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.gray)
                    })
                    .padding(.top, -10)
                    .padding(.bottom, 5)
                })
            }
        }
        .padding(.top)
        .sheet(isPresented: $showEvaluationSheet, content: {
            CollectModal(showEvaluationSheet: $showEvaluationSheet)
                .presentationDragIndicator(.visible)
//                .presentationDetents([.large, .fraction(0.8)])
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
            if status == "good" {
                Text("""
                    # 자리 골라앉기
                    # 창밖 구경
                    # 집은 이 시간에
                """)
            } else if status == "soso" {
                Text("""
                     # 호다닥 조심조심
                     # 궁둥이 들이밀기
                     # 매너있게 들이밀기
                """)
            } else if status == "bad" {
                Text("""
                # 이 시간은 피해요
                # 가방 앞으로 메기
                # 조금만 참아요
                """)
            }
        }
        .multilineTextAlignment(.center)
        .font(.system(size: 16, weight: .semibold))
    }
}
