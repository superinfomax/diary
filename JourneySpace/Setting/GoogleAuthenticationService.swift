//
//  GoogleAuthenticationService.swift
//  TextFontDemo
//
//  Created by max on 2024/11/24.
//

import GoogleSignIn
import GoogleSignInSwift

class GoogleAuthService: ObservableObject {
    @Published var isSignedIn = false
    
    static let shared = GoogleAuthService()
    
    private let clientID = "463788787726-9b0n63tkfm4ff4u612b6ekv54ashiniv.apps.googleusercontent.com"
    private let scopes = [
        "https://www.googleapis.com/auth/calendar",
        "https://www.googleapis.com/auth/calendar.events"
//        "https://www.googleapis.com/auth/tasks"
    ]
    
    init() {
            // 在初始化時檢查並恢復登入狀態
            checkSignInStatus()
        }
    
    func setupGoogleSignIn() {
        print("🔄 Setting up Google Sign-In...")
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    private func checkSignInStatus() {
        // 檢查是否有之前的登入記錄
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            print("Found previous sign-in, attempting to restore...")
            GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                if let error = error {
                    print("Failed to restore sign-in: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self?.isSignedIn = false
                    }
                    return
                }
                
                if let user = user {
                    print("Successfully restored sign-in for user: \(user.profile?.email ?? "unknown")")
                    DispatchQueue.main.async {
                        self?.isSignedIn = true
                    }
                }
            }
        } else {
            print("No previous sign-in found")
            isSignedIn = false
        }
    }
    
    func signIn(completion: @escaping (Bool) -> Void) {
        print("🔄 Starting sign in process...")
        forceSignOut() // 确保清理之前的会话
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("🔴 Failed to get root view controller")
            completion(false)
            return
        }
        
        // 请求日历权限
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController,
            hint: nil,
            additionalScopes: scopes
        ) { [weak self] result, error in
            if let error = error {
                print("🔴 Sign in error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            guard let result = result else {
                print("🔴 No sign in result")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            let grantedScopes = result.user.grantedScopes ?? []
            print("📝 Granted scopes: \(grantedScopes)")
            
            // 检查是否缺少必要范围
            let missingScopes = self?.scopes.filter { !grantedScopes.contains($0) } ?? []
            if !missingScopes.isEmpty {
                print("🔴 Missing required scopes: \(missingScopes)")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.isSignedIn = true
                completion(true)
            }
        }
    }
    
    func forceSignOut() {
        print("👋 Signing out...")
        GIDSignIn.sharedInstance.signOut()
        isSignedIn = false
    }
}
