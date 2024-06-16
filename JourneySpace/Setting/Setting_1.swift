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
    let floatingImages = ["Charlie_K", "Kevin_C", "triangleYelo", "2pCharlie", "2pKevin", "2pYelo"]
    
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
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isPressed.toggle()
                        }
                        }) {
                            Image("blackhole")
                                    .rotationEffect(.degrees(rotationAngle))
                                    .scaleEffect(isPressed ? 1.5 : 1.0) // Animate scale when pressed
                                    .onAppear {
                                        startRotation()
                                    }
                        }
                }
                .padding(.bottom, 70)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: BackpageView()) {
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
            .frame(width: 200, height: 200) // Adjust size as needed
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

//                .frame(width: 380, height: 150)
//                
//                VStack(alignment: .center, spacing: 16) {
//                    Text("開發的 第 \(daysSinceDevelop()) 天")
//                        .font(.system(size: 18))
//                    Text("Diary")
//                        .font(.system(size: 18))
//                        .multilineTextAlignment(.center)
//                }
//                .padding()
//                
//                HStack(spacing: 16) {
//                    SettingButton(title: "抽獎", imageName: "ticket.fill")
//                    SettingButton(title: "道具背包", imageName: "backpack.fill")
//                    SettingButton(title: "公告", imageName: "megaphone.fill")
//                }
//                .padding(.horizontal)
//                
//                VStack(alignment: .leading, spacing: 8) {
//                    NavigationLink(destination: Text("還想問問題？？？？")) {
//                        SettingRow(title: "經常問的問題")
//                    }
//                    NavigationLink(destination: TeamMemberView()) {
//                        SettingRow(title: "團隊成員")
//                    }
//                    NavigationLink(destination: Text("我愛東華")) {
//                        SettingRow(title: "想問的資訊")
//                    }
//                    NavigationLink(destination: Image("senbei1").scaledToFit) {
//                        SettingRow(title: "拜訪煎餅的IG")
//                    }
//                    NavigationLink(destination: Text("垃圾郵箱")) {
//                        SettingRow(title: "問題郵箱")
//                    }
//                }
//                Spacer()
//            }
//            .background(Color(UIColor.systemGray6))
//            .ignoresSafeArea()
//        }
//        .navigationBarHidden(true)
//    }
//    
//    func daysSinceDevelop() -> Int {
//        let calendar = Calendar.current
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        guard let may26 = dateFormatter.date(from: "2024/05/26") else { return 0 }
//        let currentDate = Date()
//        let components = calendar.dateComponents([.day], from: may26, to: currentDate)
//        return components.day ?? 0
//    }
//}
//
//struct SettingButton: View {
//    let title: String
//    let imageName: String
//    
//    var body: some View {
//        VStack {
//            Image(systemName: imageName)
//                .font(.system(size: 36))
//            Text(title)
//                .font(.system(size: 16))
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//
//struct SettingRow: View {
//    let title: String
//    
//    var body: some View {
//        HStack {
//            Text(title)
//                .foregroundColor(.black)
//            Spacer()
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(8)
//    }
//}
