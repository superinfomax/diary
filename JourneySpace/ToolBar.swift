//
//  menu.swift
//  JourneySpace
//
//  Created by max on 2024/6/7.
//
import SwiftUI
import Foundation
struct ToolBar: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FirstPage1()
                .tabItem {
                    Image("image_tab_bar_icon")
                }
                .tag(0)
            
            DiaryView()
                .tabItem {
                    Image("image1_tab_bar_icon")
                }
                .tag(1)
            
            TodoPage1()
                .tabItem {
                    Image("image_tab_bar_icon")
                }
                .tag(2)
            
            SettingPage1()
                .tabItem {
                    Image("image1_tab_bar_icon")
                }
                .tag(3)
        }
    }
}


