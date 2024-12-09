//
//  setting_2.swift
//  JourneySpace
//
//  Created by max on 2024/6/9.
//

import SwiftUI
import LocalAuthentication
import UserNotifications

enum AppLanguage: String, CaseIterable {
    case traditionalChinese = "繁體中文"
    // 未來可以加入其他語言
    // case english = "English"
    // case japanese = "日本語"
    
    var displayName: String {
        return self.rawValue
    }
}

func daysSinceDevelop() -> Int {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    guard let may26 = dateFormatter.date(from: "2024/05/26") else { return 0 }
    let currentDate = Date()
    let components = calendar.dateComponents([.day], from: may26, to: currentDate)
    return components.day ?? 0
}

struct LanguageSettingsView: View {
    @AppStorage("appLanguage") private var currentLanguage = AppLanguage.traditionalChinese
    private let backgroundColor = Color(red: 34/255, green: 40/255, blue: 64/255)
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                List {
                    ForEach(AppLanguage.allCases, id: \.self) { language in
                        Button(action: {
                            currentLanguage = language
                        }) {
                            HStack {
                                Text(language.displayName)
                                    .foregroundColor(.white)
                                Spacer()
                                if language == currentLanguage {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .listRowBackground(Color(red: 144/255, green: 132/255, blue: 204/255))
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(width: 350)
                .cornerRadius(10)
                
                Text("更多語言將在未來的更新中提供")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("目前使用語言")
    }
}

struct SenbeiGalleryView: View {
    private let backgroundColor = Color(red: 34/255, green: 40/255, blue: 64/255)
    private let placeholderColors: [Color] = [
        .blue.opacity(0.3),
        .purple.opacity(0.3),
        .green.opacity(0.3),
        .orange.opacity(0.3),
        .pink.opacity(0.3)
    ]
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        // 實際的煎餅照片
                        Image("senbei1")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(15)
                        
                        Image("senbei2")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(15)
                        
                        Image("senbei3")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(15)
                        Image("senbei4")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(15)
                        Image("senbei5")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(15)
                        Image("senbei6")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(15)
                        Image("senbei7")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(15)


                    }
                    .padding()
                }
                
                Spacer()
                
                Link(destination: URL(string: "https://www.google.com")!) {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.white)
                            .padding()
                        Text("拜訪煎餅的 Instagram\n（但還沒建好）")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color(red: 144/255, green: 132/255, blue: 204/255))
                    .cornerRadius(10)
                }
                .padding(.bottom, 60)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("煎餅的相簿")
    }
}

struct MailLinkView: View {
    private let backgroundColor = Color(red: 34/255, green: 40/255, blue: 64/255)
    private let emailAddress = "u11016014@go.utaipei.edu.tw"
    private let emailSubject = "[錯誤報告] 聯絡 Journal Space 團隊 "
    private let emailBody = """
    問題發生時間：
    
    詳細內容：
    
    問題情況的圖片或視頻：
    
    *如果沒有寫出詳細的描述，可能會難以解決問題和回答，請注意。
    *如果您附加了與您的查詢相關的截圖或錄影，可以快速確認和解決問題。
    """
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                Button(action: {
                    openMail()
                }) {
                    VStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 50))
                        Text("點擊寄信給我們")
                            .font(.title3)
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func openMail() {
        let subject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = emailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailtoString = "mailto:\(emailAddress)?subject=\(subject)"
        
        if let mailtoUrl = URL(string: mailtoString) {
            UIApplication.shared.open(mailtoUrl)
        }
    }
}

struct SettingsView: View {
    @AppStorage("isScreenLockOn") private var isScreenLockOn = false
    @AppStorage("isNotificationOn") private var isNotificationOn = false
    @State private var isVibrationOn = true
    @State private var showingAuth = false
    @State private var showingNotificationError = false
    @State private var showGoogleAuthSheet = false
    @State private var alertMessage = "" // 新增這行
    @StateObject private var googleAuthService = GoogleAuthService.shared
    @State private var isWaitingForSettings = false
    
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
                                } else {
                                    disableNotifications()
                                }
                            }
                            
                            NavigationLink(destination: LanguageSettingsView()) {
                                SettingRow1(title: "語言設定", imageName: "translate")
                            }
                            .foregroundColor(.white)
                            
                            NavigationLink(destination: DiaryNotificationListView()) {
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
                                ZStack {
                                    Color(red: 34/255, green: 40/255, blue: 64/255)
                                        .ignoresSafeArea()
                                    Text("開發的 第 \(daysSinceDevelop()) 天")
                                        .font(.system(size: 18))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                            ) {
                                SettingRow1(title: "開發狀況", imageName: "wrench.and.screwdriver")
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(.white)
                            
//                            NavigationLink(destination: Text("我愛東華")) {
//                                SettingRow1(title: "想問的資訊", imageName: "questionmark.circle")
//                            }
//                            .foregroundColor(.white)
                            NavigationLink(destination: SenbeiGalleryView()) {
                                SettingRow1(title: "拜訪煎餅的IG", imageName: "camera")
                            }
                            .foregroundColor(.white)
                            
//                            NavigationLink(destination:
//                                ZStack {
//                                    Color(red: 34/255, green: 40/255, blue: 64/255)
//                                        .ignoresSafeArea()
//                                    Text("我愛東華")
//                                        .font(.system(size: 18))
//                                        .multilineTextAlignment(.center)
//                                        .foregroundColor(.white)
//                                        .padding()
//                                }
//                            ) {
//                                SettingRow1(title: "想問的資訊", imageName: "questionmark.circle")
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .foregroundColor(.white)
                            
                            NavigationLink(destination: MailLinkView()) {
                                SettingRow1(title: "問題郵箱", imageName: "trash")
                            }
                            .foregroundColor(.white)
                            

                            
//                            NavigationLink(destination:
//                                ZStack {
//                                    Color(red: 34/255, green: 40/255, blue: 64/255)
//                                        .ignoresSafeArea()
//                                    
//                                    Text("垃圾郵箱")
//                                        .font(.system(size: 18))
//                                        .multilineTextAlignment(.center)
//                                        .foregroundColor(.white)
//                                        .padding()
//                                }
//                            ) {
//                                SettingRow1(title: "問題郵箱", imageName: "trash")
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .foregroundColor(.white)
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
                            message: Text(alertMessage),
                            primaryButton: .default(Text("開啟設定")) {
                                isWaitingForSettings = true
                                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(settingsUrl)
                                }
                            },
                            secondaryButton: .cancel(Text("稍後再說")) {
                                // 如果用戶取消，將開關狀態回復到實際的系統設定狀態
                                checkNotificationStatus()
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
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            if isWaitingForSettings {
                checkNotificationStatus()
                isWaitingForSettings = false
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

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    isNotificationOn = true
                } else {
                    isNotificationOn = false
                    showingNotificationError = true
                    // 設置跳轉信息
                    alertMessage = "需要開啟通知權限才能接收提醒"
                }
            }
        }
    }

    private func disableNotifications() {
        // 不直接關閉通知，而是引導用戶到系統設定
        isWaitingForSettings = true
        showingNotificationError = true
        // 設置跳轉信息
        alertMessage = "請在設定中關閉通知權限"
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

#Preview {
    SettingsView()
}
