//
//  ToDo_Item.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/9.
//

import Foundation
import SwiftData

@Model
final class ToDoItem: ObservableObject {
    var id = UUID()
    var title: String
    var timestamp: Date
    var isCritical: Bool
    var isCompleted: Bool
    private var reminderIdentifier: String?
    
    init(title: String = "",
         timestamp: Date = .now,
         isCritical: Bool = false,
         isCompleted: Bool = false) {
        self.title = title
        self.timestamp = timestamp
        self.isCritical = isCritical
        self.isCompleted = isCompleted
        self.reminderIdentifier = nil
    }
    
    func setReminderID(_ identifier: String?) {
        self.reminderIdentifier = identifier
    }
    
    func getReminderID() -> String? {
        return reminderIdentifier
    }
    
    func syncToReminders() async {
        do {
            try await RemindersManager.shared.syncToDoItemToReminders(self)
        } catch {
            print("Error syncing to Reminders: \(error)")
        }
    }
    
    func updateReminder() async {
        do {
            try await RemindersManager.shared.updateReminder(for: self)
        } catch {
            print("Error updating Reminder: \(error)")
        }
    }
    
    func deleteReminder() async {
        do {
            try await RemindersManager.shared.deleteReminder(for: self)
        } catch {
            print("Error deleting Reminder: \(error)")
        }
    }
}
