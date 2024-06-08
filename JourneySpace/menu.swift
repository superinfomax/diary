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
                    Image("image1_tab_bar_icon1")
                }
                .tag(0)
            
            // Second View
            ContentView()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Second")
                }
                .tag(1)
            
            // Third View
            Text("Third View")
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Third")
                }
                .tag(2)
            
            // Fourth View
            Text("Fourth View")
                .tabItem {
                    Image(systemName: "4.circle")
                    Text("Fourth")
                }
                .tag(3)
        }
    }
}


