//
//  DiaryEntry.swift
//  JourneySpace
//
//  Created by max on 2024/6/7.
//

import Foundation
struct DiaryEntry: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
}
