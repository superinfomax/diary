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
    @State private var isMaxRewardOn = false
    @State private var isVibrationOn = true
    @State private var showingAuth = false
    @State private var showingNotificationError = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 1) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 24))
                            .padding()
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                
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
                        .onChange(of: isNotificationOn) { value in
                            if value {
                                requestNotificationPermission()
                            }
                        }
                        
                        NavigationLink(destination: Text("語言設定")) {
                            SettingRow1(title: "語言設定", imageName: "translate")
                        }
                        .foregroundColor(.white)
                        
                        NavigationLink(destination: Text("可以設定幾點要通知使用者寫日記")) {
                            SettingRow1(title: "通知設定", imageName: "bell")
                        }
                        .foregroundColor(.white)
                    }
                    .foregroundColor(.gray)
                    .listRowBackground(Color(red: 145/255, green: 186/255, blue: 214/255).opacity(0.2))

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
                        NavigationLink(destination: Image("senbei1").scaledToFit) {
                            SettingRow1(title: "拜訪煎餅的IG", imageName: "camera")
                        }
                        .foregroundColor(.white)
                        NavigationLink(destination: Text("垃圾郵箱")) {
                            SettingRow1(title: "問題郵箱", imageName: "trash")
                        }
                        .foregroundColor(.white)
                    }
                    .foregroundColor(.gray)
                    .listRowBackground(Color(red: 145/255, green: 186/255, blue: 214/255).opacity(0.2))
                    
                    Section {
                        NavigationLink(destination: Text("個人APP連結")) {
                            SettingRow1(title: "個人", imageName: "person.crop.circle")
                        }
                        
                        NavigationLink(destination: Text("登出")) {
                            SettingRow1(title: "登出", imageName: "arrowshape.turn.up.left")
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color(red: 145/255, green: 186/255, blue: 214/255).opacity(0.2))
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
//                .tint(.pink)
                .background(Color(red: 83/255, green: 68/255, blue: 107/255))
                .scrollContentBackground(.hidden)
                
            }
        }
        // for navigationBar color
        .background(Color(red: 83/255, green: 68/255, blue: 107/255))
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
