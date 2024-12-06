//
//  CreateToDoView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/9.
//

import SwiftUI
import LocalAuthentication
import UserNotifications
import GoogleSignIn
import GoogleAPIClientForREST_Calendar

struct CreateToDoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = ToDoItem()
    @State private var selectedDate = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    private let calendarManager = GoogleCalendarManager.shared
    
    func scheduleNotification(for item: ToDoItem) {
        let content = UNMutableNotificationContent()
        content.title = "是時候完成你的ToDo了！"
        content.body = item.title
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: item.timestamp)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func createTodo() {
        isLoading = true
        item.timestamp = selectedDate
        
        // 先保存到本地
        context.insert(item)
        
        // 設置提醒
        item.scheduleNotification()
        
        // 如果有登入 Google，則同步到 Google Calendar
        if GoogleAuthService.shared.isSignedIn {
            calendarManager.createEventForToDo(item) { result in
                switch result {
                case .success(let eventId):
                    item.setGoogleEventId(eventId)
                    
                    // 同步到 Reminders
                    Task {
                        await item.syncToReminders()
                    }
                    
                    DispatchQueue.main.async {
                        isLoading = false
                        dismiss()
                    }
                    
                case .failure(let error):
                    print("Failed to sync with Google Calendar: \(error)")
                    // 即使同步失敗也繼續執行，因為已經保存在本地
                    DispatchQueue.main.async {
                        isLoading = false
                        dismiss()
                    }
                }
            }
        } else {
            // 如果沒有登入 Google，直接完成並關閉視窗
            DispatchQueue.main.async {
                isLoading = false
                dismiss()
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                TextField("What ToDo ?", text: $item.title)
                    .padding(EdgeInsets(top: 30, leading: 30, bottom: 5, trailing: 30))
                    .font(.system(size: 30))
                
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                
                DatePicker("Date & Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30))
                    .font(.system(size: 30))
                    .accentColor(Color(red: 112/255, green: 168/255, blue: 222/255))
                
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach([300, 600, 900, 1800, 3600, 7200], id: \.self) { interval in
                            Button(action: {
                                let newTime = Calendar.current.date(byAdding: .second, value: interval, to: Date())!
                                selectedDate = Calendar.current.date(
                                    bySettingHour: Calendar.current.component(.hour, from: newTime),
                                    minute: Calendar.current.component(.minute, from: newTime),
                                    second: 0,
                                    of: selectedDate
                                ) ?? selectedDate
                                item.timestamp = selectedDate
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
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                .frame(height: 50)
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
                
                Toggle("Important !!!", isOn: $item.isCritical)
                    .padding(EdgeInsets(top: 10, leading: 30, bottom: 20, trailing: 30))
                    .font(.system(size: 30))
                
                Button(action: {
                    createTodo()
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Create ToDo !")
                            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
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
        }
        .scrollDismissesKeyboard(.interactively) // 允許滾動時收起鍵盤
        .alert("提示", isPresented: $showAlert) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    CreateToDoView()
        .modelContainer(for: ToDoItem.self)
}
