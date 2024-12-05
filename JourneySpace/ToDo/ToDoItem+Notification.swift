//
//  ToDoItem+Notification.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/12/5.
//

// ToDoItem+Notification.swift

import Foundation
import UserNotifications

extension ToDoItem {
    func cancelScheduledNotification() {
        let notificationID = self.id.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
    }
    
    func scheduleNotification() {
        // 如果已完成就不要設定通知
        guard !isCompleted else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "It's time to complete your task!"
        content.body = self.title
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.timestamp)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: self.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func handleCompletionStatusChange() {
        if isCompleted {
            cancelScheduledNotification()
        } else {
            // 如果從完成改為未完成，且時間還沒到，重新設定通知
            if timestamp > Date() {
                scheduleNotification()
            }
        }
    }
}
