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
    
    @State var info: Info?
    @State var isFetchingData = false

    @State var selectedDayString: String
    
    @State var selectedTime: Date = Date()
    @State var selectedTimeString: String = ""
    
    @State var selectedSubwayStop: String = ""
    
    let buttonWidth: CGFloat = screenWidth * 0.9
    let buttonHeight: CGFloat = 80
    
    init() {
        // 현재 날짜를 가져옵니다.
        let today = Date()
        
        // Calendar를 사용하여 현재 요일을 구합니다.
        let weekdayNumber = Calendar.current.component(.weekday, from: today)
        
        // Weekday 열거형을 배열로 만들고, 요일 순서에 맞게 정렬합니다.
        let weekdays = Weekday.allCases
        // Swift의 Calendar는 일요일을 1로 시작합니다. 배열 인덱스는 0부터 시작하므로 1을 빼줍니다.
        let currentWeekday = weekdays[(weekdayNumber - 1) % weekdays.count]

        // 현재 요일의 rawValue를 selectedDayString에 할당합니다.
        self._selectedDayString = State(initialValue: currentWeekday.rawValue)
    }

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
            .padding(.leading, 20)
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
            VStack(spacing: 20) {
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
        .overlay(
            // 데이터를 가져오는 중인 경우에만 ProgressView를 표시
            isFetchingData ? ProgressView() : nil
        )
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                NavigationLink(destination: {
                    OutputPage(info: $info, selectedDayString: $selectedDayString, selectedTimeString: $selectedTimeString, selectedSubwayStop: $selectedSubwayStop)
                }, label: {
                    if !isFetchingData {
                        Text("앉을 확률 분석하기")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.blue)
                            .onTapGesture {
                                fetchDataFromServer()
                            }
                    }
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
    
    // 서버로 데이터를 비동기적으로 요청하고 처리하는 함수
    func fetchDataFromServer() {
            // 비동기적으로 데이터를 가져오는 중임을 표시
            isFetchingData = true
        
           // 실제 서버 URL을 사용하려면 여기에 해당 URL을 입력하세요.
           let serverURL = URL(string: "https://example.com/api")!

           // POST 요청을 위한 URLRequest 생성
           var request = URLRequest(url: serverURL)
           request.httpMethod = "GET"

           // JSON 데이터를 생성하여 요청 바디에 추가
            do {
                let jsonData = try JSONEncoder().encode(info)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
            }

           // 서버로 요청을 보내고 응답 처리
           URLSession.shared.dataTask(with: request) { data, response, error in
               if let data = data {
                   do {
                       // JSON 데이터를 Info 타입으로 파싱
                       let decodedInfo = try JSONDecoder().decode(Info.self, from: data)
                       DispatchQueue.main.async {
                           // 파싱된 데이터를 상태 변수에 할당
                           self.info = decodedInfo
                           self.isFetchingData = false
                       }
                   } catch {
                       print("Error decoding JSON data: \(error)")
                   }
               } else if let error = error {
                   print("Error sending POST request: \(error)")
               }
           }
           .resume()
       }
}

#Preview {
    InputPage()
}
