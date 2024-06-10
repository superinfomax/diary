//
//  mainview.swift
//  JourneySpace
//
//  Created by max on 2024/6/7.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @AppStorage("isScreenLockOn") private var isScreenLockOn = false
    @State private var showMenuView = false
    @State private var authFailed = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Journal")
                .font(.custom("AmericanTypewriter", size: 85))
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Space")
                .font(.custom("AmericanTypewriter", size: 85))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                if isScreenLockOn {
                    authenticate()
                } else {
                    showMenuView = true
                }
            }) {
                Text("Depart")
                    .font(.custom("AmericanTypewriter", size: 42))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 127/255, green: 125/255, blue: 183/255))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            
            .fullScreenCover(isPresented: $showMenuView) {
                MenuView()
            }
            
            Spacer()
        }
        .background(Color(red: 82/255, green: 78/255, blue: 124/255).edgesIgnoringSafeArea(.all))
        .alert(isPresented: $authFailed) {
            Alert(title: Text("Authentication Failed"), message: Text("Failed to authenticate, please try again."), dismissButton: .default(Text("OK")))
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate to proceed with departure"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        showMenuView = true
                    } else {
                        authFailed = true
                    }
                }
            }
        } else {
            authFailed = true
        }
    }
}
