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
    @State private var isSignedIn = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showToolbar = false
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // 背景
            Image("loginBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        hasCompletedSetup = true // 設置完成初始設定
                        showToolbar = true
                    }) {
                        Text("Skip")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.horizontal, 60)
                    }
                }
                .padding(.top, 50)
                .padding(.trailing, 20)
                
                Spacer()
                
                // Google 登入按鈕
                VStack(spacing: 20) {
                    Image(systemName: "person") // 請確保有此圖片資源
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                    
                    Text("Connect with Google")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Sync your journey across devices")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                            hasCompletedSetup = true // 設置完成初始設定
                            showToolbar = true
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                GoogleSignInButton(action: handleSignIn)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 250, height: 50)
                        .cornerRadius(5)
                        .navigationTitle("Google Calendar")
                        .alert("提示", isPresented: $showingAlert) {
                            Button("確定", role: .cancel) { }
                        } message: {
                            Text(alertMessage)
                        }
                        .onAppear {
                            checkSignInStatus()
                        }
                    }
                    .disabled(isLoading)
                }
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showToolbar) {
            ToolBar()
        }
    }
    private func checkSignInStatus() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error {
                    print("Restore sign in failed: \(error.localizedDescription)")
                    return
                }
                isSignedIn = user != nil
            }
        }
    }
    
//    private func handleSignIn() {
//        GoogleAuthService.shared.signIn { success in
//            if success {
//                isSignedIn = true
//                hasCompletedSetup = true // 設置完成初始設定
//                DispatchQueue.main.async {
//                    showToolbar = true  // 新增這行來觸發 ToolBar 的顯示
//                }
//            } else {
//                alertMessage = "登入失敗或缺少範圍"
//                showingAlert = true
//            }
//        }
//    }
    private func handleSignIn() {
        GoogleAuthService.shared.signIn { success in
            if success {
                // 如果是第一次連結，記錄時間
                if ToDoItem.firstGoogleLinkTime == nil {
                    ToDoItem.firstGoogleLinkTime = Date()
                }
                isSignedIn = true
                showToolbar = true
            } else {
                alertMessage = "登入失敗或缺少範圍"
                showingAlert = true
            }
        }
    }
}

struct GoogleAuthView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleAuthView()
    }
}

