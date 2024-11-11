import SwiftUI

struct BackpageView: View {
    let prizes: [Prize] // 獎品和名稱的數組
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(prizes.enumerated()), id: \.offset) { index, prize in
                    VStack {
                        Image(prize.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding()
                        Text(prize.name)
                            .font(.caption)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Your Prizes")
    }
}

struct Prize: Hashable {
    let imageName: String
    let name: String
}
