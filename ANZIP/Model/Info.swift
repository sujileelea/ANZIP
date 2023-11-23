//
//  Info.swift
//  ANZIP
//
//  Created by Suji Lee on 11/22/23.
//
import Foundation

struct Input: Codable {
    var month: Int?
    var day: String? // 예: "MON"
    var time: String? // 예: "12:06"
    var subwayStop: String? // 예: "어린이대공원역 7호선"
    var direction: String? // 예: "up", "down", "in", "out"
}

struct DataItem: Hashable, Codable, Identifiable {
    var id: UUID? = UUID()
    var startTime: String
    var score: Int

    // 커스텀 이니셜라이저
    init(from decoder: Decoder) throws {
        // 키 없는 컨테이너 사용
        var container = try decoder.unkeyedContainer()
        self.startTime = try container.decode(String.self)
        self.score = try container.decode(Int.self)
    }
}

struct Output: Hashable, Codable, Identifiable {
    var id: UUID? = UUID()
    var status: String?
    var data: [DataItem]? 
}
