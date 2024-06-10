//
//  setting_2.swift
//  JourneySpace
//
//  Created by max on 2024/6/9.
//

import SwiftUI
import LocalAuthentication

struct SettingsView: View {
    @AppStorage("isScreenLockOn") private var isScreenLockOn = false
    @State private var isMaxRewardOn = false
    @State private var isVibrationOn = true
    @State private var isNotificationOn = true
    @State private var showingAuth = false
    
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
                    Toggle(isOn: $isMaxRewardOn) {
                        Text("獲得煎餅")
                    }
                    Toggle(isOn: $isVibrationOn) {
                        Text("震動")
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("解決問題")) {
                        SettingRow1(title: "解決問題")
                    }
                    NavigationLink(destination: Text("語言設定")) {
                        SettingRow1(title: "語言設定")
                    }
                    NavigationLink(destination: Text("通知設定")) {
                        SettingRow1(title: "通知設定")
                    }
                }
                
                Section(header: Text("通知")) {
                    Toggle(isOn: $isNotificationOn) {
                        Text("通知")
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("個人")) {
                        SettingRow1(title: "個人")
                    }
                    NavigationLink(destination: Text("連接")) {
                        SettingRow1(title: "連接")
                    }
                    NavigationLink(destination: Text("登出")) {
                        SettingRow1(title: "登出")
                    }
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
