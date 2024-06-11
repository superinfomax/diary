import SwiftUI

struct ContentView: View {
    @State private var foregroundWidth: CGFloat = 200.0
    @State private var foregroundHeight: CGFloat = 200.0

    var body: some View {
        ZStack {
            Image("journeySpace")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all) // 填滿整個屏幕

            VStack {
                Spacer()

                Rectangle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: foregroundWidth, height: foregroundHeight)
                    .overlay(
                        VStack {
                            Text("前景內容")
                            Slider(value: $foregroundWidth, in: 100...400, step: 1) {
                                Text("Width")
                            }
                            .padding()
                            Slider(value: $foregroundHeight, in: 100...400, step: 1) {
                                Text("Height")
                            }
                            .padding()
                        }
                    )

                Spacer()
            }
        }
    }
}

struct contentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
