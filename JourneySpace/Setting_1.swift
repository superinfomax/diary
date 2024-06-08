//
//  Setting_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//

import SwiftUI
import Foundation

struct SettingPage1: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("Setting")
                        .font(.custom("KOHO", size: 96))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }

        }

          .frame(width: 430, height: 932)
          .background(
            Color(red: 71/255, green: 114/255, blue: 186/255)
          )

      }
}
