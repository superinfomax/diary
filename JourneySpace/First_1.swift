//
//  First_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//
import SwiftUI

struct FloatingImage: View {
    let imageName: String
    let imageSize: CGSize
    @State private var rotationAngle: Double = 0
    @State private var position: CGPoint
    @State private var velocity: CGPoint = CGPoint(x: 0.5, y: 0.5)
    @State private var isDragging = false
    @State private var isPaused = false

    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    init(imageName: String, imageSize: CGSize, initialPosition: CGPoint) {
        self.imageName = imageName
        self.imageSize = imageSize
        self.position = initialPosition
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: imageSize.width, height: imageSize.height)
            .rotationEffect(.degrees(rotationAngle))
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.isDragging = true
                        self.position = value.location
                        self.velocity = CGPoint(x: value.translation.width / 10, y: value.translation.height / 10)
                    }
                    .onEnded { _ in
                        self.isDragging = false
                    }
            )
            .onReceive(timer) { _ in
                guard !isDragging && !isPaused else { return }

                // 更新圖片位置
                position.x += velocity.x
                position.y += velocity.y
                
                // 檢查邊界
                if position.x > 430 {
                    position.x = 430
                    isPaused = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        position.x = 0
                        isPaused = false
                    }
                } else if position.x < 0 {
                    position.x = 0
                    isPaused = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        position.x = 430
                        isPaused = false
                    }
                }

                if position.y > 932 {
                    position.y = 932
                    isPaused = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        position.y = 0
                        isPaused = false
                    }
                } else if position.y < 0 {
                    position.y = 0
                    isPaused = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        position.y = 932
                        isPaused = false
                    }
                }

                // 隨機變換速度方向
                if Bool.random() {
                    velocity.x = CGFloat.random(in: 0...0.3)
                    velocity.y = CGFloat.random(in: 0...0.3)
                }
            }
            .onAppear {
                // 設置自轉動畫
                withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                    self.rotationAngle = 360
                }
            }
    }
}

struct FirstPage1: View {
    var body: some View {
        ZStack {
            FloatingImage(imageName: "love", imageSize: CGSize(width: 100, height: 100), initialPosition: CGPoint(x: CGFloat.random(in: 0...400), y: CGFloat.random(in: 0...900)))
            FloatingImage(imageName: "angry", imageSize: CGSize(width: 150, height: 150), initialPosition: CGPoint(x: CGFloat.random(in: 0...400), y: CGFloat.random(in: 0...900)))
        }
        .frame(width: 400, height: 932)
        .background(
            Color(red: 210/255, green: 150/255, blue: 186/255)
        )
    }
}

struct FirstPage1_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage1()
    }
}
