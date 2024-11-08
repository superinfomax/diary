//
//  ToDo_Item.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/9.
//

import Foundation
import SwiftData

@Model
final class ToDoItem: ObservableObject{
    var id = UUID() // 加入這行以確保每個 ToDoItem 都有唯一的 UUID
    var title: String
    var timestamp: Date
    var isCritical: Bool
    var isCompleted: Bool
    
    init(title: String  = "",
         timestamp: Date = .now,
         isCritical: Bool = false,
         isCompleted: Bool = false) {
        self.title = title
        self.timestamp = timestamp
        self.isCritical = isCritical
        self.isCompleted = isCompleted
    }
    
//    func getCurrentTime() -> String {
//        let formatter = DateFormatter()
//        let dateString = formatter.string(from: Date())
//        
//        return dateString
//    }
}
//import Foundation
//
//struct ToDoItem: Identifiable {
//    var id = UUID()
//    var title: String = ""
//    var date: Date = Date()
//    var isImportant: Bool = false
//}
