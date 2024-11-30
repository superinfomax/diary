//
//  RemindersObserver.swift
//  JourneySpace
//
//  Created by max on 2024/11/30.
//

import EventKit
import SwiftData

class RemindersObserver {
    static let shared = RemindersObserver()
    private let eventStore = RemindersManager.shared.eventStore
    private var modelContext: ModelContext?
    
    func startObserving(with context: ModelContext) {
        self.modelContext = context
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(remindersChanged),
            name: .EKEventStoreChanged,
            object: eventStore
        )
    }
    
    @objc private func remindersChanged() {
        Task {
            await syncRemindersToApp()
        }
    }
    
    private func fetchReminders() async -> [EKReminder] {
        guard let defaultCalendar = eventStore.defaultCalendarForNewReminders() else {
            return []
        }
        let predicate = eventStore.predicateForReminders(in: [defaultCalendar])
        
        return await withCheckedContinuation { continuation in
            eventStore.fetchReminders(matching: predicate) { reminders in
                continuation.resume(returning: reminders ?? [])
            }
        }
    }
    
    private func updateExistingItem(_ item: ToDoItem, with reminder: EKReminder) {
        item.title = reminder.title ?? ""
        if let dueDate = reminder.dueDateComponents?.date {
            item.timestamp = dueDate
        }
        item.isCompleted = reminder.isCompleted
        item.isCritical = reminder.priority == 1
    }
    
    private func createNewItem(from reminder: EKReminder, in context: ModelContext) {
        let newItem = ToDoItem(
            title: reminder.title ?? "",
            timestamp: reminder.dueDateComponents?.date ?? Date(),
            isCritical: reminder.priority == 1,
            isCompleted: reminder.isCompleted
        )
        newItem.setReminderID(reminder.calendarItemIdentifier)
        context.insert(newItem)
    }
    
    private func processReminder(_ reminder: EKReminder, existingItems: [ToDoItem], context: ModelContext) {
        let reminderID = reminder.calendarItemIdentifier
        
        for item in existingItems {
            if item.getReminderID() == reminderID {
                updateExistingItem(item, with: reminder)
                return
            }
        }
        
        createNewItem(from: reminder, in: context)
    }
    
    private func cleanupDeletedReminders(_ existingItems: [ToDoItem], currentReminders: [EKReminder], context: ModelContext) {
        let reminderIDs = Set(currentReminders.map { $0.calendarItemIdentifier })
        
        for item in existingItems {
            guard let itemReminderID = item.getReminderID() else { continue }
            if !reminderIDs.contains(itemReminderID) {
                context.delete(item)
            }
        }
    }
    
    private func syncRemindersToApp() async {
        guard let context = modelContext else { return }
        
        do {
            let reminders = await fetchReminders()
            let descriptor = FetchDescriptor<ToDoItem>()
            let existingItems = try context.fetch(descriptor)
            
            await MainActor.run {
                for reminder in reminders {
                    processReminder(reminder, existingItems: existingItems, context: context)
                }
                cleanupDeletedReminders(existingItems, currentReminders: reminders, context: context)
            }
        } catch {
            print("Error syncing reminders to app: \(error)")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
