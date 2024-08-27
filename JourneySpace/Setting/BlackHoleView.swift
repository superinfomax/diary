//
//  Setting_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//
import SwiftUI

struct BlackHoleView: View {
    @State private var rotationAngle: Double = 0
    @State private var isPressed: Bool = false
    @State private var showAlert: Bool = false
    @State private var prizeImage: Prize? = nil
    @State private var showPrizeImage: Prize? = nil
    @State private var collectedPrizes: [Prize] = []
    
    let floatingImages = ["Charlie_K", "Kevin_C", "triangleYelo", "2pCharlie", "2pKevin", "2pYelo"]
    let prizes = [
        Prize(imageName: "Charlie_K", name: "Charlie"),
        Prize(imageName: "Kevin_C", name: "Kevin"),
        Prize(imageName: "triangleYelo", name: "Triangle Yelo"),
        Prize(imageName: "2pCharlie", name: "2P Charlie"),
        Prize(imageName: "2pKevin", name: "2P Kevin"),
        Prize(imageName: "2pYelo", name: "2P Yelo")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ForEach(floatingImages, id: \.self) { imageName in
                    FloatingImage(imageName: imageName)
                }
                
                Image("blackholeCockpit")
            
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            isPressed.toggle()
                            if isPressed {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    prizeImage = prizes.randomElement()
                                    if let prizeImage = prizeImage {
                                        collectedPrizes.append(prizeImage)
                                    }
                                    showPrizeImage = prizeImage
                                    showAlert = true
                                    isPressed = false
                                }
                            }
                        }
                    }) {
                        Image("blackholeButton")
//                            .rotationEffect(.degrees(rotationAngle))
                            .scaleEffect(isPressed ? 1.2 : 1.0) // Animate scale when pressed
//                            .onAppear {
//                                startRotation()
                        }
                        .padding(.bottom, 270)
                    }
                }
                .padding(.bottom, 70)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("恭喜!"), message: Text("你抽到了新造型，可以在背包裡查看"), dismissButton: .default(Text("OK")))
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: BackpageView(prizes: collectedPrizes)) {
                            Image(systemName: "backpack.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        NavigationLink(destination: SettingsView()) {
//                            Image(systemName: "gearshape")
//                                .font(.system(size: 24))
//                                .foregroundColor(.gray)
//                        }
//                    }
                }
                .background(
                    Image("drawSpace")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }
    
//    func startRotation() {
//        withAnimation(
//            Animation.linear(duration: 5)
//                .repeatForever(autoreverses: false)
//        ) {
//            rotationAngle = 360
//        }
//    }
//}

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

struct BlackHoleView_Previews: PreviewProvider {
    static var previews: some View {
        BlackHoleView()
    }
}
