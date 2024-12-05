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
    let description: String?
    
    var isCompleted: Bool {
        return description?.contains("completed") ?? false
    }
    
    var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "\(formatter.string(from: startDate))"
    }
}
