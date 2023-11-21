//
//  InputPage.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI


enum Weekday: String, CaseIterable {
    
    case sun = "SUN", mon = "MON", tue = "TUE", wed = "WED", thu = "THU", fri = "FRI", sat = "SAT"
    
    // 요일을 변경하는 함수
    func nextDay() -> Weekday {
        switch self {
            case .sun: return .mon
            case .mon: return .tue
            case .tue: return .wed
            case .wed: return .thu
            case .thu: return .fri
            case .fri: return .sat
            case .sat: return .sun
        }
    }

    func previousDay() -> Weekday {
        switch self {
            case .sun: return .sat
            case .mon: return .sun
            case .tue: return .mon
            case .wed: return .tue
            case .thu: return .wed
            case .fri: return .thu
            case .sat: return .fri
        }
    }
}

struct InputPage: View {

    @State var selectedDayString: String = Weekday.mon.rawValue
    
    @State var selectedTime: Date = Date()
    @State var selectedTimeString: String = ""
    
    @State var selectedSubwayStop: String = ""
    
    let buttonWidth: CGFloat = screenWidth * 0.9
    let buttonHeight: CGFloat = 80

    var body: some View {
        VStack(spacing: 30) {
            //헤더
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("집으로 편하게 가려면?")
                        .font(.system(size: 23, weight: .bold))
                    VStack(alignment: .leading) {
                        Text("출발 정보를 입력해주세요 👀")
                    }
                    .font(.system(size: 18))
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 25)
            VStack(spacing: 0) {
                //요일 선택
                HStack(spacing: 50) {
                    Button(action: {
                        // selectedDay를 String 형태로 업데이트
                        self.selectedDayString = Weekday(rawValue: self.selectedDayString)?.previousDay().rawValue ?? "MON"
                    }) {
                        Image(systemName: "arrowtriangle.left.fill")
                    }
                    Image(selectedDayString)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110)
                    Button(action: {
                        // selectedDay를 String 형태로 업데이트
                        self.selectedDayString = Weekday(rawValue: self.selectedDayString)?.nextDay().rawValue ?? "MON"
                    }) {
                        Image(systemName: "arrowtriangle.right.fill")
                    }
                }
                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .foregroundStyle(Color.black)
                .font(.system(size: 20))
                //시간 선택
                HStack {
                    Text("⏰")
                    DatePicker("시간 선택", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.automatic)
                        .onChange(of: selectedTime, {
                            updateTimeString()
                        })
                    Text("⏰")
                }
                .font(.system(size: 25))
                .onAppear {
                    // 초기 시간 문자열 설정
                    updateTimeString()
                }
            }
            .padding(.bottom, 40)
            //출발역 선택
            VStack {
                Button(action: {
                    selectedSubwayStop = "어린이대공원역 7호선"
                }, label: {
                    SubwayCard(label: "어린이대공원역 7호선", lineNumber: 7)
                        .overlay {
                            if selectedSubwayStop == "어린이대공원역 7호선" {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.hexFFA800, lineWidth: 4)
                                    .frame(width: buttonWidth, height: buttonHeight)
                            }
                        }
                })
                Button(action: {
                    selectedSubwayStop = "건대입구역 7호선"
                }, label: {
                    SubwayCard(label: "건대입구역 7호선", lineNumber: 7)
                        .overlay {
                            if selectedSubwayStop == "건대입구역 7호선" {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.hexFFA800, lineWidth: 4)
                                    .frame(width: buttonWidth, height: buttonHeight)
                            }
                        }
                })
                Button(action: {
                    selectedSubwayStop = "건대입구역 2호선"
                }, label: {
                    SubwayCard(label: "건대입구역 2호선", lineNumber: 2)
                        .overlay {
                            if selectedSubwayStop == "건대입구역 2호선" {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.hexFFA800, lineWidth: 4)
                                    .frame(width: buttonWidth, height: buttonHeight)
                            }
                        }
                })
            }
            .foregroundColor(.black)
        }
        .padding(.top, -30)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                NavigationLink(destination: {
                    OutputPage(selectedDayString: $selectedDayString, selectedTimeString: $selectedTimeString, selectedSubwayStop: $selectedSubwayStop)
                }, label: {
                    Text("앉을 확률 분석하기")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color.blue)
                })
            })
        })
    }
    
    @ViewBuilder
    func SubwayCard(label: String, lineNumber: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.hex7E7E7E, lineWidth: 0.4)
                .frame(width: buttonWidth, height: buttonHeight)
            HStack {
                Text(label)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 80, height: 30)
                    .foregroundColor(lineNumber == 2 ? Color.hex1DB258 : Color.hex66741A)
                    .overlay (
                        Text("선택하기")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    )
            }
            .padding(.horizontal, 30)
        }
    }
    
    // 선택된 시간을 "hh:mm" 형태로 변환하는 함수
    private func updateTimeString() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분"
        selectedTimeString = formatter.string(from: selectedTime)
    }
}

#Preview {
    InputPage()
}
