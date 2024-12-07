//
//  GoogleAuthView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/12/2.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleAuthView: View {
    @AppStorage("hasCompletedSetup") private var hasCompletedSetup = false
    @StateObject private var googleAuthService = GoogleAuthService.shared
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showToolbar = false
    @State private var userProfileImage: UIImage?
    @State private var userEmail: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            Image("LoginAuthView_Background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                if !googleAuthService.isSignedIn {
                    // 未登入狀態的介面
                    HStack {
                        Spacer()
                        Button(action: {
                            hasCompletedSetup = true
                            dismiss()
                        }) {
                            Text("Skip")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .medium))
                                .padding(.horizontal, 60)
                        }
                    }
                    .padding(.top, 60)
                    .padding(.trailing, -20)
                } else {
                    // 已登入狀態的導航欄
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                        Spacer()
                    }
                    .padding(.top, 60)
                    .padding(.leading, 20)
                }
                
                Spacer()
                    .frame(height: 220)
                
                VStack(spacing: 20) {
                    if let profileImage = userProfileImage {
                        // 顯示Google帳號大頭照
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    } else {
                        // 預設圖示
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    
                    if googleAuthService.isSignedIn {
                        Text(userEmail)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Text("登出")
                                .foregroundColor(.white)
                                .frame(width: 250, height: 50)
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(10)
                        }
                    } else {
                        Text("連接 Google 帳戶")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("跨裝置同步你的旅程")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            isLoading = true
                            handleSignIn()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    GoogleSignInButton(action: handleSignIn)
                                }
                            }
                            .frame(width: 250, height: 50)
                            .cornerRadius(5)
                        }
                        .disabled(isLoading || googleAuthService.isSignedIn)
                    }
                }
                Spacer()
            }
        }
        .alert("確認登出", isPresented: $showLogoutAlert) {
            Button("取消", role: .cancel) { }
            Button("確定", role: .destructive) {
                googleAuthService.forceSignOut()
                userProfileImage = nil
                userEmail = ""
                dismiss()
            }
        } message: {
            Text("確定要登出嗎？")
        }
        .modelContainer(for: ToDoItem.self)
        .onAppear {
            checkSignInStatus()
        }
        .fullScreenCover(isPresented: $showToolbar) {
            ToolBar()
        }
        .alert("提示", isPresented: $showingAlert) {
            Button("確定", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    private func checkSignInStatus() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error {
                    print("Restore sign in failed: \(error.localizedDescription)")
                    return
                }
                if let user = user {
                    userEmail = user.profile?.email ?? ""
                    
                    // 獲取用戶大頭照
                    if let profilePicUrl = user.profile?.imageURL(withDimension: 200) {
                        loadProfileImage(from: profilePicUrl)
                    }
                }
            }
        }
    }
    
    private func loadProfileImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.userProfileImage = image
                }
            }
        }.resume()
    }
    
    private func handleSignIn() {
        GoogleAuthService.shared.signIn { success in
            if success {
                if ToDoItem.firstGoogleLinkTime == nil {
                    ToDoItem.firstGoogleLinkTime = Date()
                }
                checkSignInStatus() // 重新檢查狀態以獲取用戶信息
                isLoading = false
                showToolbar = true
            } else {
                isLoading = false
                alertMessage = "登入失敗或缺少範圍"
                showingAlert = true
            }
        }
    }
    
    private func signOut() {
        GoogleAuthService.shared.forceSignOut()
        userProfileImage = nil
        userEmail = ""
    }
}

struct GoogleAuthView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuthView()
    }
}

