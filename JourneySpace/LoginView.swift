//
//  mainview.swift
//  JourneySpace
//
//  Created by max on 2024/6/7.
//

import SwiftUI
import LocalAuthentication

struct Star: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat
}

struct LoginView: View {
    @AppStorage("isScreenLockOn") private var isScreenLockOn = false
    @AppStorage("hasCompletedSetup") private var hasCompletedSetup = false
    @State private var showMenuView = false
    @State private var showGoogleAuthView = false
    @State private var authFailed = false
    @State private var stars: [Star] = []
    @State private var departButtonScale: CGFloat = 1.0
    @State private var departButtonOpacity: Double = 1.0
    @ObservedObject private var authService = GoogleAuthService.shared
    private let animationDuration: TimeInterval = 1
    

    var body: some View {
        ZStack {
            Image("loginBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ForEach(stars) { star in
                Image("star")
                    .resizable()
                    .frame(width: star.size, height: star.size)
                    .position(x: star.x, y: star.y)
            }
            
            VStack {
                Spacer()
                
                Image("journeySpace")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 250)
                
                Spacer()
                
                Button(action: {
                    if isScreenLockOn {
                        authenticate()
                    } else if !hasCompletedSetup {
                        showGoogleAuthView = true
                    } else {
                        showMenuView = true
                    }
                }) {
                    Image("depart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 250)
                        .scaleEffect(departButtonScale) // 添加 scaleEffect modifier
                        .opacity(departButtonOpacity) // 添加 opacity modifier
                }
                .padding(.bottom, -150)
                .fullScreenCover(isPresented: $showGoogleAuthView) {
                    GoogleAuthView()
                }
                .fullScreenCover(isPresented: $showMenuView) {
                    ToolBar()
                }
                .onAppear {
                    startButtonAnimation()
                }
                
                Spacer()
            }
            .alert(isPresented: $authFailed) {
                Alert(title: Text("Authentication Failed"), message: Text("Failed to authenticate, please try again."), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            for _ in 0..<40 {
                let star = Star(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight),
                    size: CGFloat.random(in: 100...200),
                    speed: CGFloat.random(in: 0...1)
                )
                stars.append(star)
            }
            startStarAnimation()
        }
    }
    
    func startStarAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            withAnimation(.linear(duration: 0.01)) {
                for index in stars.indices {
                    stars[index].x -= stars[index].speed
                    stars[index].y += stars[index].speed
                    if stars[index].x < -stars[index].size || stars[index].y > UIScreen.main.bounds.height + stars[index].size {
                        let spawnFromRight = Bool.random()
                        if spawnFromRight {
                            let randomY = CGFloat.random(in: 0...(UIScreen.main.bounds.height - stars[index].size))
                            stars[index].x = UIScreen.main.bounds.width + stars[index].size
                            stars[index].y = randomY
                        } else {
                            let randomX = CGFloat.random(in: 0...(UIScreen.main.bounds.width - stars[index].size))
                            stars[index].x = randomX
                            stars[index].y = -stars[index].size
                        }
                    }
                }
            }
        }
    }
    
    func startButtonAnimation() {
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { timer in
            withAnimation {
                departButtonScale = departButtonScale == 1.0 ? 1.0 : 1.0
                departButtonOpacity = departButtonOpacity == 1.0 ? 0.5 : 1.0
            }
        }
    }

    private func checkGoogleSignIn() {
        print("Now checking Google Sign In")
        if authService.isSignedIn {
            showMenuView = true
        } else {
            showGoogleAuthView = true
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
