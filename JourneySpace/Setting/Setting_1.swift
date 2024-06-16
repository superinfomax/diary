//
//  Setting_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//
import SwiftUI

struct SettingPage1: View {
    @State private var rotationAngle: Double = 0
    @State private var isPressed: Bool = false
    @State private var showAlert: Bool = false
    @State private var prizeImage: String? = nil
    @State private var showPrizeImage: String? = nil
    let floatingImages = ["Charlie_K", "Kevin_C", "triangleYelo", "2pCharlie", "2pKevin", "2pYelo"]
    let prizes = ["Charlie_K", "Kevin_C", "triangleYelo", "2pCharlie", "2pKevin", "2pYelo"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("drawSpace")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                ForEach(floatingImages, id: \.self) { imageName in
                    FloatingImage(imageName: imageName)
                }
                
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            isPressed.toggle()
                            if isPressed {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    prizeImage = prizes.randomElement()
                                    showPrizeImage = prizeImage
                                    showAlert = true
                                    isPressed = false
                                }
                            }
                        }
                    }) {
                        Image("blackhole")
                            .rotationEffect(.degrees(rotationAngle))
                            .scaleEffect(isPressed ? 2.0 : 1.0) // Animate scale when pressed
                            .onAppear {
                                startRotation()
                            }
                    }
                }
                .padding(.bottom, 70)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("恭喜!"), message: Text("你抽到了新造型，可以在背包做查看"), dismissButton: .default(Text("OK")))
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: BackpageView(prizeImage: showPrizeImage)) {
                            Image(systemName: "backpack.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
    
    func startRotation() {
        withAnimation(
            Animation.linear(duration: 5)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
    }
}

struct FloatingImage: View {
    let imageName: String
    @State private var position: CGPoint = .zero
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .position(position)
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                startFloating()
                startRotation()
            }
    }
    
    private func startFloating() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        position = CGPoint(x: CGFloat.random(in: 0...screenWidth), y: CGFloat.random(in: 0...screenHeight))
        
        withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: true)) {
            position = CGPoint(x: CGFloat.random(in: 0...screenWidth), y: CGFloat.random(in: 0...screenHeight))
        }
    }
    
    private func startRotation() {
        withAnimation(
            Animation.linear(duration: 10).repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
    }
}

struct SettingPage1_Previews: PreviewProvider {
    static var previews: some View {
        SettingPage1()
    }
}
