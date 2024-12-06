//
//  DiaryNotificationSettingsView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/12/6.
//

import SwiftUI
import UserNotifications

struct DiaryNotificationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notificationTime = Date()
    @State private var selectedDays = [Bool](repeating: true, count: 7)
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // 用來暫存修改的值
    @State private var tempSelectedDays = [Bool](repeating: true, count: 7)
    @State private var tempNotificationTime = Date()
    
    private let daysOfWeek = ["一", "二", "三", "四", "五", "六", "日"]
    private let backgroundColor = Color(red: 34/255, green: 40/255, blue: 64/255)
    private let accentColor = Color(red: 144/255, green: 132/255, blue: 204/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 100) {
                    // 星期選擇器
                    VStack(alignment: .leading, spacing: 10) {
                        Text("提醒日期")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                        
                        HStack(spacing: 15) {
                            ForEach(Array(daysOfWeek.enumerated()), id: \.0) { index, day in
                                DayButton(
                                    day: day,
                                    isSelected: tempSelectedDays[index],
                                    action: {
                                        tempSelectedDays[index].toggle()
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // 時間選擇器
                    VStack(alignment: .leading, spacing: 10) {
                        Text("提醒時間")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                        
                        DatePicker("", selection: $tempNotificationTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top, 50)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                // 修改 toolbar 中的完成按鈕部分
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        // 檢查是否至少選擇一天
                        if !tempSelectedDays.contains(true) {
                            alertMessage = "請至少選擇一天作為提醒日期"
                            showAlert = true
                            return
                        }
                        
                        // 更新實際的值
                        selectedDays = tempSelectedDays
                        notificationTime = tempNotificationTime
                        
                        // 儲存設定
                        UserDefaults.standard.set(selectedDays, forKey: "selectedDaysForDiary")
                        UserDefaults.standard.set(notificationTime, forKey: "diaryNotificationTime")
                        
                        // 更新通知
                        updateNotifications()
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("編輯提醒時間")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .alert("提示", isPresented: $showAlert) {
                Button("確定", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
        .onAppear {
            loadSavedSettings()
        }
    }
    
    private func loadSavedSettings() {
        if let savedDays = UserDefaults.standard.array(forKey: "selectedDaysForDiary") as? [Bool] {
            selectedDays = savedDays
            tempSelectedDays = savedDays
        }
        if let savedTime = UserDefaults.standard.object(forKey: "diaryNotificationTime") as? Date {
            notificationTime = savedTime
            tempNotificationTime = savedTime
        }
    }
    
    private func updateNotifications() {
        // 只移除日記相關的提醒
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let diaryIdentifiers = requests
                .filter { $0.identifier.hasPrefix("DiaryReminder-") }
                .map { $0.identifier }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: diaryIdentifiers)
            print("已移除舊的日記提醒：\(diaryIdentifiers.count) 個")
        }
        
        // 檢查通知權限
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                DispatchQueue.main.async {
                    alertMessage = "請在設定中開啟通知權限"
                    showAlert = true
                    print("通知權限未開啟")
                }
                return
            }
            
            // 為每個選中的日期建立日記提醒
            var successCount = 0
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            for (index, isSelected) in selectedDays.enumerated() {
                guard isSelected else {
                    print("週\(index + 1)未設置提醒")
                    continue
                }
                
                let content = UNMutableNotificationContent()
                content.title = "日記提醒"
                content.body = "今天發生了什麼有趣的事情嗎？來寫下你的心情吧！"
                content.sound = .default
                content.userInfo = ["type": "diary"]
                
                var components = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
                let weekday = index + 2
                components.weekday = weekday == 8 ? 1 : weekday
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let request = UNNotificationRequest(
                    identifier: "DiaryReminder-\(index)",
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("設置日記提醒失敗（週\(index + 1)）：\(error.localizedDescription)")
                    } else {
                        successCount += 1
                        let weekdayText = ["一", "二", "三", "四", "五", "六", "日"][index]
                        print("成功設置週\(weekdayText)的日記提醒，時間：\(formatter.string(from: notificationTime))")
                        
                        // 當所有提醒都設置完成時
                        if successCount == selectedDays.filter({ $0 }).count {
                            print("\n日記提醒設置完成摘要：")
                            print("設置時間：\(formatter.string(from: notificationTime))")
                            print("已啟用的日期：\(selectedDays.enumerated().filter { $0.1 }.map { ["一", "二", "三", "四", "五", "六", "日"][$0.0] }.joined(separator: "、"))")
                            print("總計設置：\(successCount) 個提醒")
                        }
                    }
                }
            }
        }
    }
}

// 自定義元件
struct DayButton: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color(red: 144/255, green: 132/255, blue: 204/255) : Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                Text(day)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
            }
        }
    }
}



#Preview {
    DiaryNotificationSettingsView()
}
