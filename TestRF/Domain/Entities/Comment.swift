//
//  Comment.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import Foundation

struct Comment: Identifiable, Codable {
    var id: Int
    var by: String
    var text: String
    var time: TimeInterval
}
