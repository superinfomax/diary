//
//  ToDo_Item.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/9.
//

import Foundation
import SwiftData
import EventKit

@Model
final class ToDoItem: ObservableObject {
    
    var id = UUID()
    var title: String
    var timestamp: Date
    var isCritical: Bool
//    var isCompleted: Bool
    var googleEventId: String?
    var completedId: String?

    var isCompleted: Bool {
        didSet {
            if oldValue != isCompleted {
                handleCompletionStatusChange()
            }
        }
    }
    
    static var firstGoogleLinkTime: Date? {
            get {
                if let date = UserDefaults.standard.object(forKey: "firstGoogleLinkTime") as? Date {
                    return date
                }
                return nil
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "firstGoogleLinkTime")
            }
        }
    private var reminderIdentifier: String?
    
    var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "\(formatter.string(from: timestamp))"
    }
    
    init(title: String = "",
         timestamp: Date = .now,
         isCritical: Bool = false,
         isCompleted: Bool = false) {
        self.title = title
        self.timestamp = timestamp
        self.isCritical = isCritical
        self.isCompleted = isCompleted
        self.reminderIdentifier = nil
        self.googleEventId = nil
    }
    
    // 現有的 Reminder 相關方法
    func setReminderID(_ identifier: String?) {
        self.reminderIdentifier = identifier
    }
    
    func getReminderID() -> String? {
        return reminderIdentifier
    }
    
    func setGoogleEventId(_ eventId: String?) {
        self.googleEventId = eventId
    }
    
    func getGoogleEventId() -> String? {
        return googleEventId
    }
    
    // 同步到 Google Calendar
    func syncToGoogleCalendar(calendarManager: GoogleCalendarManager, completion: @escaping (Bool) -> Void) {
        calendarManager.createEvent(
            title: self.title,
            startDate: self.timestamp,
            endDate: self.timestamp
        ) { result in
            switch result {
            case .success(let event):
                self.setGoogleEventId(event.identifier)
                completion(true)
            case .failure(let error):
                print("Error syncing to Google Calendar: \(error)")
                completion(false)
            }
        }
    }
    
    // 更新 Google Calendar 事件
    func updateGoogleCalendarEvent(calendarManager: GoogleCalendarManager, completion: @escaping (Bool) -> Void) {
        // 如果有 Google Calendar 事件 ID，則更新事件
        guard let eventId = googleEventId else {
            // 如果沒有 ID，則創建新事件
            syncToGoogleCalendar(calendarManager: calendarManager, completion: completion)
            return
        }
    }
    
    // 刪除 Google Calendar 事件
    func deleteGoogleCalendarEvent(calendarManager: GoogleCalendarManager, completion: @escaping (Bool) -> Void) {
        guard let eventId = googleEventId else {
            completion(true)
            return
        }
        
        calendarManager.deleteEvent(with: eventId) { result in
            switch result {
            case .success:
                self.googleEventId = nil
                completion(true)
            case .failure(let error):
                print("Error deleting Google Calendar event: \(error)")
                completion(false)
            }
        }
    }
    
    // 現有的 Reminders 同步方法
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
    
    
    func markAsCompleted() {
        isCompleted = true
        if completedId == nil {
            completedId = UUID().uuidString
        }
    }
    
    
}
