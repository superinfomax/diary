//
//  BackbageView.swift
//  JourneySpace
//
//  Created by ㄚˇㄌㄛˋ on 2024/6/16.
//

import SwiftUI

struct BackpageView: View {
    @EnvironmentObject var prizeManager: PrizeManager // 使用 @EnvironmentObject 存取共享狀態
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                // 使用 prizeManager.collectedPrizes 來展示收集的獎勵
                ForEach(prizeManager.collectedPrizes, id: \.self) { prize in
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
