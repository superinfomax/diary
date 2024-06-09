//
//  Setting_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//
import SwiftUI

struct SettingPage1: View {
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 24))
                            .padding()
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 380, height: 150)
                
                VStack(alignment: .center, spacing: 16) {
                    Text("開發的 第 \(daysSinceDevelop()) 天")
                        .font(.system(size: 18))
                    Text("大統領 ❤️ 小統領")
                        .font(.system(size: 18))
                    Text("石雅箬 ❤️ 社恐煎餅")
                        .font(.system(size: 18))
                    Text("我們的Diary")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                HStack(spacing: 16) {
                    SettingButton(title: "便條紙", imageName: "folder.fill")
                    SettingButton(title: "道具背包", imageName: "backpack.fill")
                    SettingButton(title: "公告", imageName: "megaphone.fill")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    NavigationLink(destination: Text("常見問題的問題")) {
                        SettingRow(title: "經常問的問題")
                    }
                    NavigationLink(destination: Text("詢問想問團隊")) {
                        SettingRow(title: "詢問想問團隊")
                    }
                    NavigationLink(destination: Text("我的想問資訊")) {
                        SettingRow(title: "我的想問資訊")
                    }
                    NavigationLink(destination: Text("拜訪煎餅的IG")) {
                        SettingRow(title: "拜訪煎餅的IG")
                    }
                    NavigationLink(destination: Text("想問的問題郵箱")) {
                        SettingRow(title: "想問的問題郵箱")
                    }
                }
                Spacer()
            }
            .background(Color(UIColor.systemGray6))
            .ignoresSafeArea()
        }
        .navigationBarHidden(true) // Hide the navigation bar to prevent the default back button
    }
    
    func daysSinceDevelop() -> Int {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let june8 = dateFormatter.date(from: "2024/06/07") else { return 0 }
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: june8, to: currentDate)
        return components.day ?? 0
    }
}

struct SettingButton: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: 36))
            Text(title)
                .font(.system(size: 16))
        }
        .frame(maxWidth: .infinity)
    }
}

struct SettingRow: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
}
