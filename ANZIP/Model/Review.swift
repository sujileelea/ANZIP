//
//  Review.swift
//  ANZIP
//
//  Created by Suji Lee on 11/22/23.
//

import Foundation

struct Review: Codable {
    var score: Int = 0 // 1 ~ 5
    var comment: String = "" // 100자 제한
}
