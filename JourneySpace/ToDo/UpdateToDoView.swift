//
//  UpdateToDoView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/10.
//

import SwiftUI
import SwiftData
import UserNotifications

struct UpdateToDoView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var item: ToDoItem
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    private let calendarManager = GoogleCalendarManager.shared
    
    func scheduleNotification(for item: ToDoItem) {
        let notificationID = item.id.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])

        let content = UNMutableNotificationContent()
        content.title = "It's time to complete your task!"
        content.body = item.title
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: item.timestamp)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateTodoWithGoogleCalendar() {
        isLoading = true
        
        // 更新 Google Calendar 事件
        calendarManager.updateEventForToDo(item) { result in
            switch result {
            case .success:
                // 更新通知
                scheduleNotification(for: item)
                
                // 更新 Reminder
                Task {
                    await item.updateReminder()
                }
                
                DispatchQueue.main.async {
                    isLoading = false
                    dismiss()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    isLoading = false
                    // 如果沒有對應的 Google Calendar 事件，則創建一個新的
                    if error.localizedDescription.contains("No Google Calendar event ID found") {
                        createNewGoogleCalendarEvent()
                    } else {
                        alertMessage = "更新 Google Calendar 事件失敗: \(error.localizedDescription)"
                        showAlert = true
                    }
                }
            }
        }
    }
    
    private func createNewGoogleCalendarEvent() {
        calendarManager.createEventForToDo(item) { result in
            switch result {
            case .success(let eventId):
                item.setGoogleEventId(eventId)
                DispatchQueue.main.async {
                    isLoading = false
                    dismiss()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    isLoading = false
                    alertMessage = "創建 Google Calendar 事件失敗: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }

    var body: some View {
        ScrollView{
            VStack {
                TextField("What ToDo ?", text: $item.title)
                    .padding(EdgeInsets(top: 30, leading: 30, bottom: 5, trailing: 30))
                    .font(.system(size: 30))
                
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30))
                
                DatePicker("", selection: $item.timestamp)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30))
                    .font(.system(size: 30))
                    .accentColor(Color(red: 112/255, green: 168/255, blue: 222/255))
                
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach([300, 600, 900, 1800, 3600, 7200], id: \.self) { interval in
                            Button(action: {
                                item.timestamp = Date().addingTimeInterval(TimeInterval(interval))
                            }) {
                                Text("\(interval / 60)")
                                    .fontWeight(.bold)
                                    .font(.callout)
                                    .frame(width: geometry.size.width / 6, height: 50)
                            }
                            .background(Color(red: 112/255, green: 168/255, blue: 222/255))
                            .foregroundColor(.white)
                            .cornerRadius(0)
                        }
                    }
                    .background(Color(red: 71/255, green: 114/255, blue: 186/255))
                    .cornerRadius(15)
                }
                .frame(height: 50)
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                
                Toggle("Important !!!", isOn: $item.isCritical)
                    .padding(EdgeInsets(top: 10, leading: 30, bottom: 20, trailing: 30))
                    .font(.system(size: 30))
                
                Button(action: {
                    updateTodoWithGoogleCalendar()
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Update")
                            .fontWeight(.bold)
                            .font(.title)
                    }
                }
                .disabled(isLoading)
                .padding()
                .background(Color(red: 112/255, green: 168/255, blue: 222/255))
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            .navigationTitle("Update ToDo")
        }
        .alert("提示", isPresented: $showAlert) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

//#Preview {
//    UpdateToDoView()
//        .modelContainer(for: ToDoItem.self)
//}
