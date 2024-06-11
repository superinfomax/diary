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
    @State private var scrollAmount: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Image("loginBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(0..<20, id: \.self) { _ in
                                    Image("star")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 500, height: 600) // 可根據需要調整尺寸
                                }
                            }
                        }
            
            VStack {
                Spacer()
                
                Image("journeySpace")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
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
                    ToolBar()
                }
                
                Spacer()
            }
            .alert(isPresented: $authFailed) {
                Alert(title: Text("Authentication Failed"), message: Text("Failed to authenticate, please try again."), dismissButton: .default(Text("OK")))
        }
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
