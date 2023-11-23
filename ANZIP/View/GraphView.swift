import SwiftUI

struct GraphView: View {
    
    let data: [(String, Int)] = [("11", 1), ("12", 3), ("13", 9), ("14", 10), ("15", 5)]
    let xAxisLength: CGFloat = 315
    let yAxisLength: CGFloat = 220
    let xOffset: CGFloat = 30 // x축 좌표 간격 조정

    var body: some View {
        ZStack(alignment: .topLeading) {
              // 축을 그립니다.
              Path { path in
                  // x축
                  path.move(to: CGPoint(x: xOffset, y: yAxisLength))
                  path.addLine(to: CGPoint(x: xAxisLength + xOffset, y: yAxisLength))

                  // y축
                  path.move(to: CGPoint(x: xOffset, y: 0))
                  path.addLine(to: CGPoint(x: xOffset, y: yAxisLength))
              }
              .stroke(Color.hex7E7E7E, lineWidth: 0.7)

              // 시간 구간에 따른 가로선 그리기, 색상 적용 및 점선 안내선 추가
              ForEach(data.indices, id: \.self) { index in
                  let xPositionStart = xOffset + 30 + xAxisLength / CGFloat(data.count + 1) * CGFloat(index)
                  let xPositionEnd = xOffset + 30 + xAxisLength / CGFloat(data.count + 1) * CGFloat(index + 1)
                  let yPosition = yAxisLength - (yAxisLength / 10 * CGFloat(data[index].1))

                  // 가로선 그리기
                  Path { path in
                      path.move(to: CGPoint(x: xPositionStart, y: yPosition))
                      path.addLine(to: CGPoint(x: xPositionEnd, y: yPosition))
                  }
                  .stroke(self.colorForValue(data[index].1), lineWidth: 4)

                  // 점선 안내선 그리기
                  Path { path in
                      path.move(to: CGPoint(x: xPositionStart, y: 0))
                      path.addLine(to: CGPoint(x: xPositionStart, y: yAxisLength))
                      path.move(to: CGPoint(x: xPositionEnd, y: 0))
                      path.addLine(to: CGPoint(x: xPositionEnd, y: yAxisLength))
                  }
                  .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5, 5]))
              }

            // 데이터 값 라벨을 추가합니다.
            ForEach(data, id: \.0) { dataPoint in
                let index = data.firstIndex(where: { $0.0 == dataPoint.0 }) ?? 0
                let xPosition = xOffset + 50 + xAxisLength / CGFloat(data.count + 1) * CGFloat(index)
                let yPosition = yAxisLength - (yAxisLength / 10 * CGFloat(dataPoint.1))

                Text("\(dataPoint.1)")
                    .position(x: xPosition, y: yPosition - 20)
                    .foregroundStyle(Color.hex7E7E7E)
                    .font(.system(size: 11))
            }

            // x축 레이블을 추가합니다.
            ForEach(data.indices, id: \.self) { index in
                Text(data[index].0)
                    .position(x: xOffset + 30 + xAxisLength / CGFloat(data.count + 1) * CGFloat(index), y: yAxisLength + 20)
            }

            // 마지막 데이터 포인트 다음 시간의 x축 레이블 추가
            if let lastTime = data.last?.0, let lastHour = Int(lastTime) {
                let nextHour = lastHour + 1
                Text("\(nextHour)")
                    .position(x: xOffset + 30 + xAxisLength / CGFloat(data.count + 1) * CGFloat(data.count), y: yAxisLength + 20)
            }

            // y축 레이블을 추가합니다.
            ForEach([1, 4, 7, 10], id: \.self) { value in
                Text("\(value)")
                    .font(.system(size: 12))
                    .position(x: xOffset - 20, y: yAxisLength - (yAxisLength / 10 * CGFloat(value)))
            }
        }
        .frame(width: xAxisLength + xOffset * 2, height: yAxisLength + 40) // 그래프 크기 조정
        .padding(.leading, 10) // y축 레이블을 위한 공간 추가
    }

    func colorForValue(_ value: Int) -> Color {
        switch value {
        case 1...4:
            return .red
        case 5...7:
            return .yellow
        default:
            return .green
        }
    }
}
