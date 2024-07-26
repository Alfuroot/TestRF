//
//  Story.swift
//  TestRF
//
//  Created by Giuseppe Carannante on 26/07/2024.
//

import Foundation

struct Story: Identifiable, Codable {
    let id: Int
    let title: String
    let kids: [Int]?
    let url: String?
    let by: String
    let text: String?
    let time: TimeInterval
    let score: Int
    let descendants: Int?
}
