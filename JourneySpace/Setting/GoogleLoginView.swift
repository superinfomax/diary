//
//  GoogleLoginView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/12/2.
//

import SwiftUI
import GoogleSignIn

struct GoogleLoginView: View {
    @State private var isLoggedIn = false
    @State private var showBlackHoleView = false
    
    var body: some View {
        VStack {
            if isLoggedIn {
                Text("Logged in with Google")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    showBlackHoleView = true
                }) {
                    Text("Continue to BlackHoleView")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showBlackHoleView) {
                    BlackHoleView()
                }
            } else {
                Text("Login with Google to sync your calendar events")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { signInResult, error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else {
                            isLoggedIn = true
                        }
                    }
                }) {
                    Text("Login with Google")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    showBlackHoleView = true
                }) {
                    Text("Continue without login")
                        .font(.subheadline)
                        .padding()
                }
                .fullScreenCover(isPresented: $showBlackHoleView) {
                    BlackHoleView()
                }
            }
        }
    }
    
    private func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

#Preview {
    GoogleLoginView()
}
