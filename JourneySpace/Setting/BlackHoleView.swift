//
//  Setting_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//
import SwiftUI

struct BlackHoleView: View {
    @EnvironmentObject var prizeManager: PrizeManager // 使用共享的 PrizeManager
    @State private var rotationAngle: Double = 0
    @State private var isPressed: Bool = false
    @State private var showAlert: Bool = false
    @State private var prizeImage: Prize? = nil
    @State private var showPrizeImage: Prize? = nil
    @State private var collectedPrizes: [Prize] = []
    @State private var RightisBlinking = false // 控制閃爍效果
    @State private var LeftisBlinking = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.setBackIndicatorImage(UIImage(systemName: "chevron.backward"),
                                         transitionMaskImage: UIImage(systemName: "chevron.backward"))
        UINavigationBar.appearance().tintColor = .white
            
        // 設置返回鍵的顏色
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor:UIColor.systemBlue]
            
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
    }
    
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
                                        prizeManager.collectedPrizes.append(prizeImage) // 更新共享的獎勵清單
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
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .padding(.leading, 320)
                        .opacity(RightisBlinking ? 0.2 : 0.7) // 不透明度變化
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                RightisBlinking.toggle() // 觸發狀態變化來開始閃爍
                            }
                        }
                    
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .padding(.trailing, 320)
                        .opacity(LeftisBlinking ? 0.2 : 0.7) // 不透明度變化
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                LeftisBlinking.toggle() // 觸發狀態變化來開始閃爍
                            }
                        }
                }
                .padding(.bottom, 70)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("恭喜!"), message: Text("你抽到了新造型，可以在背包裡查看"), dismissButton: .default(Text("OK")))
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: BackpageView()) {
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
    @ObservedObject private var viewModel = FloatingImageViewModel()

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .position(viewModel.position)
            .rotationEffect(.degrees(viewModel.rotationAngle))
            .onAppear {
                viewModel.startFloating()
                viewModel.startRotation()
            }
    }
}




struct BlackHoleView_Previews: PreviewProvider {
    static var previews: some View {
        BlackHoleView()
    }
}
