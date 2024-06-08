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
                    Image("image_tab_bar_icon")
                }
                .tag(0)
            
            ContentView()
                .tabItem {
                    Image("image1_tab_bar_icon")
                }
                .tag(1)
            
            TodoPage1()
                .tabItem {
                    Image("image_tab_bar_icon")
                }
                .tag(2)
            
            Text("setting View")
                .tabItem {
                    Image("image1_tab_bar_icon")
                }
                .tag(3)
        }
    }
}


