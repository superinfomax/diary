//
//  RemindersManager.swift
//  JourneySpace
//
//  Created by max on 2024/11/27.
//

import EventKit
import SwiftData

class RemindersManager {
    static let shared = RemindersManager()
    private let eventStore = EKEventStore()
    
    func requestAccess() async throws -> Bool {
        if #available(iOS 17.0, *) {
            return try await eventStore.requestFullAccessToReminders()
        } else {
            return await withCheckedContinuation { continuation in
                eventStore.requestAccess(to: .reminder) { granted, error in
                    continuation.resume(returning: granted)
                }
            }
        }
    }
    
    func syncToDoItemToReminders(_ item: ToDoItem) async throws {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = item.title
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: item.timestamp)
        reminder.priority = item.isCritical ? 1 : 0
        reminder.isCompleted = item.isCompleted
        
        try eventStore.save(reminder, commit: true)
        item.setReminderID(reminder.calendarItemIdentifier)
    }
    
    func updateReminder(for item: ToDoItem) async throws {
        guard let reminderID = item.getReminderID(),
              let reminder = try? eventStore.calendarItem(withIdentifier: reminderID) as? EKReminder else {
            try await syncToDoItemToReminders(item)
            return
        }
        
        reminder.title = item.title
        reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: item.timestamp)
        reminder.priority = item.isCritical ? 1 : 0
        reminder.isCompleted = item.isCompleted
        
        try eventStore.save(reminder, commit: true)
    }
    
    func deleteReminder(for item: ToDoItem) async throws {
        guard let reminderID = item.getReminderID(),
              let reminder = try? eventStore.calendarItem(withIdentifier: reminderID) as? EKReminder else {
            return
        }
        
        try eventStore.remove(reminder, commit: true)
    }
}
