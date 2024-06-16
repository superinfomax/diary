//
//  BackbageView.swift
//  JourneySpace
//
//  Created by ㄚˇㄌㄛˋ on 2024/6/16.
//

import SwiftUI
import Foundation

struct BackpageView: View {
    let prizeImage: String?
    
    var body: some View {
        VStack {
            if let prizeImage = prizeImage {
                Image(prizeImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                Text("這是你獲得的新造型")
                    .font(.title)
                    .padding()
            } else {
                Text("還沒有造型喔")
                    .font(.title)
                    .padding()
            }
        }
        .navigationTitle("Your Prize")
    }
}
