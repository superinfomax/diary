//
//  DiaryNotificationSettingsView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/12/6.
//

import SwiftUI
import UserNotifications

// 用於儲存每個提醒設定的結構
struct DiaryReminderSetting: Identifiable, Codable, Equatable {
    let id: UUID
    var selectedDays: [Bool]
    var notificationTime: Date
    
    init(id: UUID = UUID(), selectedDays: [Bool] = Array(repeating: false, count: 7), notificationTime: Date = Date()) {
        self.id = id
        self.selectedDays = selectedDays
        self.notificationTime = notificationTime
    }
    
    static func == (lhs: DiaryReminderSetting, rhs: DiaryReminderSetting) -> Bool {
        return lhs.id == rhs.id &&
               lhs.selectedDays == rhs.selectedDays &&
               lhs.notificationTime == rhs.notificationTime
    }
}

// 提醒設定列表視圖
struct DiaryNotificationListView: View {
    @State private var reminderSettings: [DiaryReminderSetting] = []
    @State private var showAddReminder = false
    @State private var selectedSetting: DiaryReminderSetting?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    
    private let daysOfWeek = ["一", "二", "三", "四", "五", "六", "日"]
    private let backgroundColor = Color(red: 34/255, green: 40/255, blue: 64/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 通知權限警告
                    if notificationStatus != .authorized {
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("未開啟通知權限，將無法收到提醒")
                                    .foregroundColor(.white)
                                Spacer()
                                Button("設定") {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                .foregroundColor(.blue)
                            }
                            .padding()
                        }
                        .background(Color.black.opacity(0.3))
                    }
                    
                    if reminderSettings.isEmpty {
                        Text("尚未設置提醒時間")
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    } else {
                        List {
                            ForEach(reminderSettings) { setting in
                                ReminderRow(setting: setting)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedSetting = setting
                                    }
                            }
                            .onDelete(perform: deleteReminder)
                        }
                        .padding(.bottom, 30)
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("日記提醒時間")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        selectedSetting = nil
                        showAddReminder = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddReminder) {
            DiaryNotificationSettingsView(
                existingSetting: selectedSetting,
                onSave: { newSetting in
                    if let index = reminderSettings.firstIndex(where: { $0.id == selectedSetting?.id }) {
                        reminderSettings[index] = newSetting
                    } else {
                        reminderSettings.append(newSetting)
                    }
                    saveSettings()
                    updateNotifications()
                }
            )
        }
        .onChange(of: selectedSetting) { _ in
            if selectedSetting != nil {
                showAddReminder = true
            }
        }
        .onAppear {
            loadSettings()
            checkNotificationStatus()
        }
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationStatus = settings.authorizationStatus
            }
        }
    }
    
        private func deleteReminder(at offsets: IndexSet) {
        reminderSettings.remove(atOffsets: offsets)
        saveSettings()
        updateNotifications()
    }
    
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(reminderSettings) {
            UserDefaults.standard.set(encoded, forKey: "diaryReminderSettings")
        }
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "diaryReminderSettings"),
           let decoded = try? JSONDecoder().decode([DiaryReminderSetting].self, from: data) {
            reminderSettings = decoded
        }
    }
    
    private func updateNotifications() {
        // 移除所有現有的日記提醒
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let diaryIdentifiers = requests
                .filter { $0.identifier.hasPrefix("DiaryReminder-") }
                .map { $0.identifier }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: diaryIdentifiers)
        }
        
        // 設置新的提醒
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                DispatchQueue.main.async {
                    alertMessage = "請在設定中開啟通知權限"
                    showAlert = true
                }
                return
            }
            
            // 為每個提醒設定建立通知
            for setting in reminderSettings {
                for (dayIndex, isEnabled) in setting.selectedDays.enumerated() where isEnabled {
                    let content = UNMutableNotificationContent()
                    content.title = "日記提醒"
                    content.body = "今天發生了什麼有趣的事情嗎？來寫下你的心情吧！"
                    content.sound = .default
                    
                    var components = Calendar.current.dateComponents([.hour, .minute], from: setting.notificationTime)
                    let weekday = dayIndex + 2
                    components.weekday = weekday == 8 ? 1 : weekday
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    let identifier = "DiaryReminder-\(setting.id)-\(dayIndex)"
                    
                    let request = UNNotificationRequest(
                        identifier: identifier,
                        content: content,
                        trigger: trigger
                    )
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("設置提醒失敗: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}

struct DiaryNotificationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    let existingSetting: DiaryReminderSetting?
    let onSave: (DiaryReminderSetting) -> Void
    
    @State private var tempSelectedDays: [Bool]
    @State private var tempNotificationTime: Date
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let daysOfWeek = ["一", "二", "三", "四", "五", "六", "日"]
    private let backgroundColor = Color(red: 34/255, green: 40/255, blue: 64/255)
    private let accentColor = Color(red: 144/255, green: 132/255, blue: 204/255)
    
    init(existingSetting: DiaryReminderSetting? = nil, onSave: @escaping (DiaryReminderSetting) -> Void) {
            self.existingSetting = existingSetting
            self.onSave = onSave
            
            // 如果是編輯現有設定，使用現有的值；如果是新增，則全部設為未選取
            if let existing = existingSetting {
                _tempSelectedDays = State(initialValue: existing.selectedDays)
                _tempNotificationTime = State(initialValue: existing.notificationTime)
            } else {
                _tempSelectedDays = State(initialValue: Array(repeating: false, count: 7))
                _tempNotificationTime = State(initialValue: Date())
            }
        }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 100) {
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        if !tempSelectedDays.contains(true) {
                            alertMessage = "請至少選擇一天作為提醒日期"
                            showAlert = true
                            return
                        }
                        
                        let newSetting = DiaryReminderSetting(
                            id: existingSetting?.id ?? UUID(),
                            selectedDays: tempSelectedDays,
                            notificationTime: tempNotificationTime
                        )
                        
                        onSave(newSetting)
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .principal) {
                    Text(existingSetting == nil ? "新增提醒" : "編輯提醒")
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
    }
}

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

struct ReminderRow: View {
    let setting: DiaryReminderSetting
    private let daysOfWeek = ["一", "二", "三", "四", "五", "六", "日"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 時間
            Text(setting.notificationTime.formatted(date: .omitted, time: .shortened))
                .font(.title2)
                .foregroundColor(.white)
            
            // 選中的星期
            HStack(spacing: 8) {
                ForEach(Array(daysOfWeek.enumerated()), id: \.0) { index, day in
                    if setting.selectedDays[index] {
                        Text(day)
                            .font(.system(size: 14))
                            .padding(8)
                            .background(Color(red: 144/255, green: 132/255, blue: 204/255))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .listRowBackground(Color(red: 34/255, green: 40/255, blue: 64/255))
        .listRowSeparatorTint(.white)
    }
    
}

#Preview {
    DiaryNotificationListView()
}
