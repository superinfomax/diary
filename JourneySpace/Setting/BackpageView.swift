import SwiftUI

struct BackpageView: View {
    

    
    @EnvironmentObject var prizeManager: PrizeManager
    let prizes: [Prize]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(prizeManager.collectedPrizes.enumerated()), id: \.offset) { index, prize in
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
        .toolbarBackground(Color.blue, for: .navigationBar)
    }
}

struct Prize: Hashable {
    let imageName: String
    let name: String
}
