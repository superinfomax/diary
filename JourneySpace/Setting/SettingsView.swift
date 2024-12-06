//
//  setting_2.swift
//  JourneySpace
//
//  Created by max on 2024/6/9.
//

import SwiftUI
import LocalAuthentication
import UserNotifications

func daysSinceDevelop() -> Int {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    guard let may26 = dateFormatter.date(from: "2024/05/26") else { return 0 }
    let currentDate = Date()
    let components = calendar.dateComponents([.day], from: may26, to: currentDate)
    return components.day ?? 0
}

struct SettingsView: View {
    @AppStorage("isScreenLockOn") private var isScreenLockOn = false
    @AppStorage("isNotificationOn") private var isNotificationOn = false
    @State private var isVibrationOn = true
    @State private var showingAuth = false
    @State private var showingNotificationError = false
    @State private var showGoogleAuthSheet = false
    @StateObject private var googleAuthService = GoogleAuthService.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 1) {
                    Form {
                        Section(header: Text("系統設定")) {
                            Toggle(isOn: $isScreenLockOn) {
                                Text("螢幕鎖定")
                            }
                            .foregroundColor(.white)
                            .onChange(of: isScreenLockOn) { value in
                                if value {
                                    authenticate()
                                }
                            }
                            Toggle(isOn: $isNotificationOn) {
                                Text("通知")
                            }
                            .foregroundColor(.white)
                            .onChange(of: isNotificationOn) { newValue in
                                if newValue {
                                    requestNotificationPermission()
                                }
                            }
                            
                            NavigationLink(destination: Text("語言設定")) {
                                SettingRow1(title: "語言設定", imageName: "translate")
                            }
                            .foregroundColor(.white)
                            
                            NavigationLink(destination: DiaryNotificationSettingsView()) {
                                SettingRow1(title: "通知設定", imageName: "bell")
                            }
                            .foregroundColor(.white)
                        }
                        .foregroundColor(.gray)
                        .listRowBackground(Color(red: 144/255, green: 132/255, blue: 204/255))
                        
                        Section(header: Text("有關團隊")) {
                            NavigationLink(destination: TeamMemberView()) {
                                SettingRow1(title: "團隊成員", imageName: "person.2")
                            }
                            .foregroundColor(.white)
                            
                            NavigationLink(destination:
                                            Text("開發的 第 \(daysSinceDevelop()) 天")
                                .font(.system(size: 18))
                                .multilineTextAlignment(.center)
                                .padding()) {
                                    SettingRow1(title: "開發狀況", imageName: "wrench.and.screwdriver")
                                }
                                .foregroundColor(.white)
                            
                            NavigationLink(destination: Text("我愛東華")) {
                                SettingRow1(title: "想問的資訊", imageName: "questionmark.circle")
                            }
                            .foregroundColor(.white)
                            
                            NavigationLink(destination: Image("senbei1").scaledToFit()) {
                                SettingRow1(title: "拜訪煎餅的IG", imageName: "camera")
                            }
                            .foregroundColor(.white)
                            
                            NavigationLink(destination: Text("垃圾郵箱")) {
                                SettingRow1(title: "問題郵箱", imageName: "trash")
                            }
                            .foregroundColor(.white)
                        }
                        .foregroundColor(.gray)
                        .listRowBackground(Color(red: 144/255, green: 132/255, blue: 204/255))
                        
                        Section(header: Text("其他")) {
                            Button(action: {
                                showGoogleAuthSheet = true
                            }) {
                                SettingRow1(title: "個人", imageName: "person.crop.circle")
                            }
                        }
                        .foregroundColor(.gray)
                        .listRowBackground(Color(red: 144/255, green: 132/255, blue: 204/255))
                    }
                    .onAppear {
                        checkNotificationStatus()
                        if isScreenLockOn {
                            authenticate()
                        }
                    }
                    .alert(isPresented: $showingAuth) {
                        Alert(title: Text("認證失敗"), message: Text("無法進行身份驗證，請重試。"), dismissButton: .default(Text("確定")))
                    }
                    .alert(isPresented: $showingNotificationError) {
                        Alert(
                            title: Text("通知權限"),
                            message: Text("需要開啟通知權限才能接收提醒"),
                            primaryButton: .default(Text("開啟設定")) {
                                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsUrl)
                                }
                            },
                            secondaryButton: .cancel(Text("稍後再說")) {
                                isNotificationOn = false
                            }
                        )
                    }
                    .tint(Color(red: 34/255, green: 40/255, blue: 64/255))
                    .background(Color(red: 34/255, green: 40/255, blue: 64/255))
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color(red: 34/255, green: 40/255, blue: 64/255))
            .fullScreenCover(isPresented: $showGoogleAuthSheet) {
                GoogleAuthView()
                    .modelContainer(for: ToDoItem.self)
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "需要您的認證以啟用螢幕鎖定功能"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isScreenLockOn = true
                    } else {
                        isScreenLockOn = false
                        showingAuth = true
                    }
                }
            }
        } else {
            isScreenLockOn = false
            showingAuth = true
        }
    }
    
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                isNotificationOn = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // 請求通知權限
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                isNotificationOn = granted
                if !granted {
                    showingNotificationError = true
                }
            }
        }
    }
    
    // 打開系統設置
    private func openSystemSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    struct SettingRow1: View {
        let title: String
        let imageName: String
        
        var body: some View {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
