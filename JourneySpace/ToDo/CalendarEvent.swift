//
//  CalendarEvent.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/12/3.
//

import Foundation

struct CalendarEvent: Identifiable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    let colorHex: String?
    
    var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "\(formatter.string(from: startDate))"
    }
}
