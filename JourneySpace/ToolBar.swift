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
                    Image("tapBar1_" + (selectedTab == 0 ? "2" : "1"))
                }
                .tag(0)
            
            DiaryView()
                .tabItem {
                    Image("tapBar2_" + (selectedTab == 1 ? "2" : "1"))
                }
                .tag(1)
            
            TodoPage1()
                .tabItem {
                    Image("tapBar3_" + (selectedTab == 2 ? "2" : "1"))
                }
                .tag(2)
            
            SettingPage1()
                .tabItem {
                    Image("tapBar4_" + (selectedTab == 3 ? "2" : "1"))
                }
                .tag(3)
        }
    }
}


struct ToolBar_Previews: PreviewProvider {
    static var previews: some View {
        ToolBar()
    }
}
