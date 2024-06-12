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
    @State private var showMenuView = false
    @State private var authFailed = false
    @State private var stars: [Star] = []

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
                    } else {
                        showMenuView = true
                    }
                }) {
                    Image("depart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 250)
                }
                .padding(.bottom, -150)
                .fullScreenCover(isPresented: $showMenuView) {
                    ToolBar()
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
            
            for _ in 0..<5 {
                let star = Star(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight),
                    size: CGFloat.random(in: 450...900),
                    speed: CGFloat.random(in: 0...1)
                )
                stars.append(star)
            }
            startStarAnimation()
        }
    }
    
    func startStarAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            withAnimation(.linear(duration: 0.01)) {
                for index in stars.indices {
                    stars[index].x -= stars[index].speed
                    stars[index].y += stars[index].speed
                    if stars[index].x < -stars[index].size || stars[index].y > UIScreen.main.bounds.height + stars[index].size {
                        stars[index].x = UIScreen.main.bounds.width + stars[index].size
                        stars[index].y = -stars[index].size
                    }
                }
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
