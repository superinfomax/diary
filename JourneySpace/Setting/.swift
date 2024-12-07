//
//  SenbeiGalleryView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/12/7.
//

struct SenbeiGalleryView: View {
    private let backgroundColor = Color(red: 34/255, green: 40/255, blue: 64/255)
    private let placeholderColors: [Color] = [
        .blue.opacity(0.3),
        .purple.opacity(0.3),
        .green.opacity(0.3),
        .orange.opacity(0.3),
        .pink.opacity(0.3)
    ]
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        // 實際的煎餅照片
                        Image("senbei1")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(15)
                        
                        // 使用純色佔位的照片
                        ForEach(0..<5, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 15)
                                .fill(placeholderColors[index % placeholderColors.count])
                                .frame(width: 300, height: 300)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Link(destination: URL(string: "https://www.google.com")!) {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.white)
                        Text("Visit Senbei's Instagram")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color(red: 144/255, green: 132/255, blue: 204/255))
                    .cornerRadius(10)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("煎餅的相簿")
    }
}

// 更新 SettingsView 中的導航
NavigationLink(destination: SenbeiGalleryView()) {
    SettingRow1(title: "拜訪煎餅的IG", imageName: "camera")
}
.foregroundColor(.white)

#Preview {
    NavigationView {
        SenbeiGalleryView()
    }
}
