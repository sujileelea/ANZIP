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
    
    @Binding var pageIndex: PageIndex
    
    @Binding var inputData: Input
    @Binding var outputData: Output

    @State var selectedMonth: Int
    @State var selectedDayString: String
    
    @State var selectedTime: Date = Date()
    @State var selectedTimeString: String = ""
    
    @State var selectedSubwayStop: String = ""
    @State var selectedDirection: String = ""
    
    @State var isFetchingData = false
    
    let buttonWidth: CGFloat = screenWidth * 0.9
    let buttonHeight: CGFloat = 53
    
    let startTime: Date
    let endTime: Date
    
    init(pageIndex: Binding<PageIndex>, inputData: Binding<Input>, outputData: Binding<Output>) {
        self._pageIndex = pageIndex
        
        self._inputData = inputData
        
        self._outputData = outputData
        
        // 현재 날짜를 가져옵니다.
        let today = Date()
        
        // Calendar를 사용하여 현재 요일을 구합니다.
        let weekdayNumber = Calendar.current.component(.weekday, from: today)
        
        // Weekday 열거형을 배열로 만들고, 요일 순서에 맞게 정렬합니다.
        let weekdays = Weekday.allCases
        // Swift의 Calendar는 일요일을 1로 시작합니다. 배열 인덱스는 0부터 시작하므로 1을 빼줍니다.
        let currentWeekday = weekdays[(weekdayNumber - 1) % weekdays.count]
        
        let month = Calendar.current.component(.month, from: Date())
        self._selectedMonth = State(initialValue: month)
        
        // 현재 요일의 rawValue를 selectedDayString에 할당합니다.
        self._selectedDayString = State(initialValue: currentWeekday.rawValue)
        
        // 6:00 AM과 자정을 나타내는 Date 객체 생성
        let calendar = Calendar.current
        self.startTime = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
        self.endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!

        // 현재 시간이 선택 범위 내에 있는지 확인하고, 아니면 6:00 AM으로 설정
        let currentTime = Date()
        if currentTime < startTime || currentTime > endTime {
            self._selectedTime = State(initialValue: startTime)
        } else {
            self._selectedTime = State(initialValue: currentTime)
        }
    }

    var body: some View {
        NavigationStack {
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
                .padding(.top, 30)
                .padding(.bottom, -10)
                VStack(spacing: 0) {
                    //요일 선택
                    HStack(spacing: 40) {
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
                    // 월 및 시간 선택
                    HStack(spacing: 35) {
                        // 월 선택
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: 155, height: 60)
                            .overlay {
                                Menu(content: {
                                    ForEach(1...12, id: \.self) { month in
                                        Button("\(month)월") {
                                            selectedMonth = month
                                        }
                                    }
                                }, label: {
                                    HStack {
                                        Text("🗓️")
                                        Text("\(selectedMonth)월")
                                            .font(.system(size: 18))
                                            .frame(width: 80)
                                    }
                                })
                            }
                        //시간 선택
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: 155, height: 60)
                            .overlay(alignment: .bottom, content: {
                                Text("6:30부터 23:00까지 선택 가능")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color.hex7E7E7E)
                                    .offset(x:1, y: 16)
                            })
                            .overlay {
                                HStack {
                                    Text("⏰")
                                    // DatePicker의 시간 범위 설정
                                    DatePicker("시간 선택", selection: $selectedTime, in: startTime...endTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .datePickerStyle(.automatic)
                                        .onChange(of: selectedTime, {
                                            updateTimeString()
                                        })
                                }
                                .onAppear {
                                    // 초기 시간 문자열 설정
                                    updateTimeString()
                                }
                            }
                    }
                    .font(.system(size: 25))
                    .foregroundStyle(Color.black)
                }
                .padding(.bottom, 20)
                //출발역 선택
                VStack(spacing: 22) {
                    VStack(spacing: 9) {
                        Button(action: {
                            selectedSubwayStop = "어린이대공원역 7호선"
                            selectedDirection = "up"
                        }, label: {
                            SubwayCard(label: "어린이대공원역 7호선 (상행)", lineNumber: 7)
                                .overlay {
                                    if selectedSubwayStop == "어린이대공원역 7호선" && selectedDirection == "up" {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.hexFFA800, lineWidth: 4)
                                            .frame(width: buttonWidth, height: buttonHeight)
                                    }
                                }
                        })
                        Button(action: {
                            selectedSubwayStop = "어린이대공원역 7호선"
                            selectedDirection = "down"
                        }, label: {
                            SubwayCard(label: "어린이대공원역 7호선 (하행)", lineNumber: 7)
                                .overlay {
                                    if selectedSubwayStop == "어린이대공원역 7호선" && selectedDirection == "down" {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.hexFFA800, lineWidth: 4)
                                            .frame(width: buttonWidth, height: buttonHeight)
                                    }
                                }
                        })
                    }
                    VStack(spacing: 9) {
                        Button(action: {
                            selectedSubwayStop = "건대입구역 7호선"
                            selectedDirection = "up"
                        }, label: {
                            SubwayCard(label: "건대입구역 7호선 (상행)", lineNumber: 7)
                                .overlay {
                                    if selectedSubwayStop == "건대입구역 7호선" && selectedDirection == "up" {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.hexFFA800, lineWidth: 4)
                                            .frame(width: buttonWidth, height: buttonHeight)
                                    }
                                }
                        })
                        Button(action: {
                            selectedSubwayStop = "건대입구역 7호선"
                            selectedDirection = "down"
                        }, label: {
                            SubwayCard(label: "건대입구역 7호선 (하행)", lineNumber: 7)
                                .overlay {
                                    if selectedSubwayStop == "건대입구역 7호선" && selectedDirection == "down" {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.hexFFA800, lineWidth: 4)
                                            .frame(width: buttonWidth, height: buttonHeight)
                                    }
                                }
                        })
                    }
                    VStack(spacing: 9) {
                        Button(action: {
                            selectedSubwayStop = "건대입구역 2호선"
                            selectedDirection = "in"
                        }, label: {
                            SubwayCard(label: "건대입구역 2호선 (내선)", lineNumber: 2)
                                .overlay {
                                    if selectedSubwayStop == "건대입구역 2호선" && selectedDirection == "in" {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.hexFFA800, lineWidth: 4)
                                            .frame(width: buttonWidth, height: buttonHeight)
                                    }
                                }
                        })
                        Button(action: {
                            selectedSubwayStop = "건대입구역 2호선"
                            selectedDirection = "out"
                        }, label: {
                            SubwayCard(label: "건대입구역 2호선 (외선)", lineNumber: 2)
                                .overlay {
                                    if selectedSubwayStop == "건대입구역 2호선" && selectedDirection == "out" {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.hexFFA800, lineWidth: 4)
                                            .frame(width: buttonWidth, height: buttonHeight)
                                    }
                                }
                        })
                    }
                }
                .foregroundColor(.black)
            }
            .padding(.top, -10)
                    .overlay (
             //데이터를 가져오는 중인 경우에만 ProgressView를 표시
                        isFetchingData ? CustomProgressView() : nil
                    )
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        fetchDataFromServer(inputDataToServer: inputData)
                    }, label: {
                        if !isFetchingData {
                            Text("앉을 확률 분석하기")
                                .font(.system(size: 17, weight: selectedSubwayStop == "" ? .medium : .bold))
                                .foregroundStyle(selectedSubwayStop == "" ? Color.hex7E7E7E :Color.hexFFA800)
                        }
                    })
                    .disabled(selectedSubwayStop == "")
                })
            })
        }
    }
    
    @ViewBuilder
    func SubwayCard(label: String, lineNumber: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.hex7E7E7E, lineWidth: 0.7)
                .frame(width: buttonWidth, height: buttonHeight)
            HStack {
                Text(label)
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 60, height: 25)
                    .foregroundColor(lineNumber == 2 ? Color.hex1DB258 : Color.hex66741A)
                    .overlay (
                        Text("선택")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .regular))
                    )
            }
            .padding(.horizontal, 30)
        }
    }
    
    // 선택된 시간을 "hh:mm" 형태로 변환하는 함수
    private func updateTimeString() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var timeString = formatter.string(from: selectedTime)

        // 시간 부분의 첫 번째 문자가 '0'인 경우 제거
        if timeString.hasPrefix("0") {
            timeString.removeFirst()
        }

        selectedTimeString = timeString
    }
    
    // 서버로 데이터를 비동기적으로 요청하고 처리하는 함수
    func fetchDataFromServer(inputDataToServer: Input) {
        
        inputData.month = selectedMonth
        inputData.day = selectedDayString
        inputData.time = selectedTimeString
        inputData.subwayStop = selectedSubwayStop
        inputData.direction = selectedDirection
        print("fetchDataFromServer 함수 호출")
            // 비동기적으로 데이터를 가져오는 중임을 표시
            isFetchingData = true
        
           // 실제 서버 URL을 사용하려면 여기에 해당 URL을 입력하세요.
           let serverURL = URL(string: "https://anzip-api-davidlee.koyeb.app/send")!

           // POST 요청을 위한 URLRequest 생성
           var request = URLRequest(url: serverURL)
           request.httpMethod = "POST"
        
            print("리퀘스트 : ", request)

            print("인포 데이터: ", inputData)
        
           // JSON 데이터를 생성하여 요청 바디에 추가
            do {
                let jsonData = try JSONEncoder().encode(inputData)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
            }
        
        
           // 서버로 요청을 보내고 응답 처리
           URLSession.shared.dataTask(with: request) { data, response, error in
               if let data = data {
                   do {
                       // JSON 데이터를 Info 타입으로 파싱
                       let decodedData = try JSONDecoder().decode(Output.self, from: data)
                       DispatchQueue.main.async {
                           // 파싱된 데이터를 상태 변수에 할당
                           print("반환 데이터 : ", decodedData)
                           outputData = decodedData
                           self.isFetchingData = false
                           pageIndex = .outputPage
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
