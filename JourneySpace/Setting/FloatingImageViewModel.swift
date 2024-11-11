import SwiftUI

class FloatingImageViewModel: ObservableObject {
    @Published var position: CGPoint
    @Published var rotationAngle: Double = 0
    private var screenWidth: CGFloat
    private var screenHeight: CGFloat
    private var isFirstAnimation = true // 控制第一次動畫

    init() {
        self.screenWidth = UIScreen.main.bounds.width
        self.screenHeight = UIScreen.main.bounds.height
        self.position = CGPoint(x: CGFloat.random(in: 0...screenWidth), y: CGFloat.random(in: 0...screenHeight))
        
    }

    func startFloating() {
        
        let newX = CGFloat.random(in: 0...screenWidth)
        let newY = CGFloat.random(in: 0...screenHeight)
        
        // 使用較短的初始延遲，避免動畫瞬間完成
        let delay = isFirstAnimation ? 0.1 : 0
        isFirstAnimation = false // 更新標記，防止後續的額外延遲
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: true)) {
                self.position = CGPoint(x: newX, y: newY)
            }
            
            // 在動畫完成後調用自身以保持連續
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.startFloating()
            }
        }
    }
    
    func startRotation() {
        let delay = isFirstAnimation ? 0.1 : 0
        isFirstAnimation = false

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                self.rotationAngle = 360
            }

            // 在動畫完成後再次調用自身以保持連續
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.startRotation()
            }
        }
    }
}
