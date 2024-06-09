//
//  TeamMemberView.swift
//  JourneySpace
//
//  Created by max on 2024/6/9.
//

import SwiftUI
struct TeamMember: Identifiable {
    var id = UUID()
    var name: String
    var role: String
    var image: String
}
struct TeamMemberView: View {
    let teamMembers: [TeamMember] = [
        TeamMember(name: "邱茂齊", role: "iOS Developer", image: "max"),
        TeamMember(name: "邱子君", role: "iOS Developer", image: "jessie"),
        TeamMember(name: "石雅箬", role: "UI/UX Designer", image: "charlie"),
        TeamMember(name: "i煎餅", role: "Project Manager", image: "senbei_team")
    ]
    
    var body: some View {
        VStack {
            Text("Our Team")
                .font(.largeTitle)
                .bold()
                .padding()
            
            ForEach(teamMembers) { member in
                HStack(spacing: 16) {
                    Image(member.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 3)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(member.name)
                            .font(.title2)
                            .bold()
                        
                        Text(member.role)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            Spacer()
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("Team Members")
    }
}

struct TeamMemberView_Previews: PreviewProvider {
    static var previews: some View {
        TeamMemberView()
    }
}
