//
//  Info.swift
//  ANZIP
//
//  Created by Suji Lee on 11/22/23.
//

import Foundation

struct Input: Codable {
    var month: Int?
    var day: String? // "MON"
    var time: String? // "12:06"
    var subwayStop: String? // "어린이대공원역 7호선"
    var direction: String? // "up" "down" "in" "out"
}

struct Output: Codable {
    var status: String? // "Good" "Soso" "Bad
//    var data: Dictionary<String, Int>? // [("11", 1), ("12", 3)]
    var datas: Array<DataTuple>?
}

struct DataTuple: Hashable ,Codable {
    var startTime: String?
    var score: Int?
}
