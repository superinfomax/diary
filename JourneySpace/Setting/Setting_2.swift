//
//  setting_2.swift
//  JourneySpace
//
//  Created by max on 2024/6/9.
//

import SwiftUI
import LocalAuthentication
import UserNotifications

struct SettingsView: View {
    @AppStorage("isScreenLockOn") private var isScreenLockOn = false
    @AppStorage("isNotificationOn") private var isNotificationOn = false
    @State private var isMaxRewardOn = false
    @State private var isVibrationOn = true
    @State private var showingAuth = false
    @State private var showingNotificationError = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 24))
                        .padding()
                }
                Spacer()
                Text("Setting")
                    .font(.custom("AmericanTypewriter", size: 24))
                Spacer()
            }
            .padding(.horizontal)
            
            Form {
                Section(header: Text("系統設定")) {
                    Toggle(isOn: $isScreenLockOn) {
                        Text("螢幕鎖定")
                    }
                    .onChange(of: isScreenLockOn) { value in
                        if value {
                            authenticate()
                        }
                    }
                    
                    NavigationLink(destination: Text("語言設定")) {
                        SettingRow1(title: "語言設定")
                    }
                    
                    NavigationLink(destination: Text("可以設定幾點要通知使用者寫日記")) {
                        SettingRow1(title: "通知設定")
                    }
                    
                    Toggle(isOn: $isNotificationOn) {
                        Text("通知")
                    }
                    .onChange(of: isNotificationOn) { value in
                        if value {
                            requestNotificationPermission()
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("個人相關APP連結")) {
                        SettingRow1(title: "個人")
                    }
                    
                    NavigationLink(destination: Text("登出")) {
                        SettingRow1(title: "登出")
                    }
                }
            }
            .onAppear {
                if isScreenLockOn {
                    authenticate()
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showingAuth) {
                Alert(title: Text("認證失敗"), message: Text("無法進行身份驗證，請重試。"), dismissButton: .default(Text("確定")))
            }
            .alert(isPresented: $showingNotificationError) {
                Alert(title: Text("通知失敗"), message: Text("無法開啟通知，請檢查您的設定。"), dismissButton: .default(Text("確定")))
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
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    isNotificationOn = true
                } else {
                    isNotificationOn = false
                    showingNotificationError = true
                }
            }
        }
    }
    
    struct SettingRow1: View {
        let title: String
        
        var body: some View {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                Spacer()
            }
        }
    }
}
