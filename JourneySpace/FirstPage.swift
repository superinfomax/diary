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
    @State private var velocity: CGPoint = CGPoint(x: 0.3, y: 0.3)
    @State private var isDragging = false

    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    init(imageName: String, imageSize: CGSize, initialPosition: CGPoint) {
        self.imageName = imageName
        self.imageSize = imageSize
        self._position = State(initialValue: initialPosition)
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
                guard !isDragging else { return }

                // 更新图片位置
                position.x += velocity.x
                position.y += velocity.y

                // 检查边界并平滑处理
                if position.x > 430 - imageSize.width / 2 {
                    position.x = 430 - imageSize.width / 2
                    velocity.x = -velocity.x * 0.7 // 减少速度，模拟更弱的反弹
                } else if position.x < imageSize.width / 2 {
                    position.x = imageSize.width / 2
                    velocity.x = -velocity.x * 0.7
                }

                if position.y > 932 - imageSize.height / 2 {
                    position.y = 932 - imageSize.height / 2
                    velocity.y = -velocity.y * 0.7
                } else if position.y < imageSize.height / 2 {
                    position.y = imageSize.height / 2
                    velocity.y = -velocity.y * 0.7
                }

                // 随机变换速度方向
                velocity.x += CGFloat.random(in: -0.05...0.05)
                velocity.y += CGFloat.random(in: -0.05...0.05)
            }
            .onAppear {
                // 设置自转动画
                withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                    self.rotationAngle = 360
                }
            }
    }
}

struct FirstPage1: View {
    var body: some View {
        ZStack {
            FloatingImage(imageName: "love", imageSize: CGSize(width: 100, height: 100), initialPosition: CGPoint(x: CGFloat.random(in: 50...350), y: CGFloat.random(in: 50...850)))
            FloatingImage(imageName: "angry", imageSize: CGSize(width: 150, height: 150), initialPosition: CGPoint(x: CGFloat.random(in: 75...325), y: CGFloat.random(in: 75...825)))
            FloatingImage(imageName: "happy", imageSize: CGSize(width: 150, height: 150), initialPosition: CGPoint(x: CGFloat.random(in: 75...325), y: CGFloat.random(in: 75...825)))
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
