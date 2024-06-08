//
//  menu.swift
//  JourneySpace
//
//  Created by max on 2024/6/7.
//
import SwiftUI
import Foundation
struct MenuView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("first View")
                .tabItem {
                    Image("Image")
                }
                .tag(0)
            
            // Second View
            ContentView()
                .tabItem {
                    Image("Image")
                }
                .tag(1)
            
            // Third View
            Text("Third View")
                .tabItem {
                    Image("Image")
                }
                .tag(2)
            
            // Fourth View
            Text("Fourth View")
                .tabItem {
                    Image("Image")
                }
                .tag(3)
        }
    }
}


