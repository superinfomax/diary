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
                Text("This is your prize!")
                    .font(.title)
                    .padding()
            } else {
                Text("No prize won yet.")
                    .font(.title)
                    .padding()
            }
        }
        .navigationTitle("Your Prize")
    }
}
