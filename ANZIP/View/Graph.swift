//
//  Graph.swift
//  ANZIP
//
//  Created by Suji Lee on 11/21/23.
//

import SwiftUI

struct GraphView: View {
    let data: [(String, Int)] = [("a", 1), ("b", 3), ("c", 9), ("d", 10), ("e", 5)]
    let xAxisLength: CGFloat = 220
    let yAxisLength: CGFloat = 190
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

            // 데이터 포인트와 선을 그립니다.
            Path { path in
                for (index, dataPoint) in data.enumerated() {
                    let xPosition = xOffset + 25 + xAxisLength / CGFloat(data.count) * CGFloat(index)
                    let yPosition = yAxisLength - (yAxisLength / 10 * CGFloat(dataPoint.1))

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    } else {
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
            }
            .stroke(Color.hex7E7E7E, lineWidth: 0.7)

            // 데이터 포인트에 원을 그립니다.
            ForEach(data, id: \.0) { dataPoint in
                let index = data.firstIndex(where: { $0.0 == dataPoint.0 }) ?? 0
                let xPosition = xOffset + 25 + xAxisLength / CGFloat(data.count) * CGFloat(index)
                let yPosition = yAxisLength - (yAxisLength / 10 * CGFloat(dataPoint.1))

                Circle()
                    .fill(self.colorForValue(dataPoint.1))
                    .frame(width: 10, height: 10)
                    .position(x: xPosition, y: yPosition)

                // 데이터 값 라벨을 추가합니다.
                Text("\(dataPoint.1)")
                    .position(x: xPosition, y: yPosition - 20)
            }

            // x축 레이블을 추가합니다.
            ForEach(data.indices, id: \.self) { index in
                Text(data[index].0)
                    .position(x: xOffset + 25 + xAxisLength / CGFloat(data.count) * CGFloat(index), y: yAxisLength + 20)
            }

            // y축 레이블을 추가합니다.
            ForEach([1, 4, 7, 10], id: \.self) { value in
                Text("\(value)")
                    .position(x: xOffset - 20, y: yAxisLength - (yAxisLength / 10 * CGFloat(value)))
            }
        }
        .frame(width: xAxisLength + xOffset * 2, height: yAxisLength + 40) // 그래프 크기 조정
        .padding(.leading, 40) // y축 레이블을 위한 공간 추가
    }

    func colorForValue(_ value: Int) -> Color {
        switch value {
        case 1...4:
            return .red
        case 4...7:
            return .yellow
        default:
            return .green
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
