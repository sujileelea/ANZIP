//
//  Info.swift
//  ANZIP
//
//  Created by Suji Lee on 11/22/23.
//

import Foundation

struct Info: Codable {
//    var month: ?
    var day: String? // "MON"
    var time: String? // "12:06"
    var subwayStop: String? // "어린이대공원역 7호선"
    var direction: String? // "up" "down" "in" "out"
    
    var status: String? // "Good" "Soso" "Bad
    var data: Dictionary<String, Int>? // [("11", 1), ("12", 3)]
}
