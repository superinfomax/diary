import SwiftUI

struct InfiniteTabView: View {
    @Environment(\.dismiss) private var dismiss  // 允許返回 ContentView
    @State private var currentIndex = 0
    @State private var selectedTab = 0
    let views: [AnyView] = [
        AnyView(FirstPage1()),
        AnyView(BlackHoleView())
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 顯示當前頁面
                views[currentIndex]
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: currentIndex)
                
                // 左側按鈕
                VStack {
                    Spacer()
                    HStack {
                        Button(action: moveToPrevious) {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        // 返回 ContentView 的按鈕
                        Button("Back") {
                            dismiss()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Spacer()
                        // 右側按鈕
                        Button(action: moveToNext) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // 切換到下一頁
    private func moveToNext() {
        currentIndex = (currentIndex + 1) % views.count
    }
    
    // 切換到上一頁
    private func moveToPrevious() {
        currentIndex = (currentIndex - 1 + views.count) % views.count
    }
}
