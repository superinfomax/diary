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
        TeamMember(name: "石雅箬", role: "UI/UX Designer\nProject Manager's Owner", image: "roi"),
        TeamMember(name: "i煎餅", role: "Project Manager", image: "senbei_team")
    ]
    
    @State private var selectedMember: TeamMember?
    
    var body: some View {
        ZStack {
            ForEach(teamMembers) { member in
                FloatingMemberView(member: member)
                    .onTapGesture {
                        selectedMember = member
                    }
            }
        }
        .background(Color(red: 34/255, green: 40/255, blue: 64/255).edgesIgnoringSafeArea(.all))
        .sheet(item: $selectedMember) { member in
            VStack {
                Spacer()
                Image(member.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    .shadow(radius: 3)
                
                Text(member.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                Text(member.role)
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct FloatingMemberView: View {
    let member: TeamMember
    @State private var position: CGPoint
    @State private var velocity: CGPoint = CGPoint(x: CGFloat.random(in: -0.5...0.5), y: CGFloat.random(in: -0.5...0.5))
    @State private var isDragging = false
    @State private var rotationAngle: Double = 0
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    init(member: TeamMember) {
        self.member = member
        self._position = State(initialValue: CGPoint(x: CGFloat.random(in: 100...300), y: CGFloat.random(in: 100...600)))
    }
    
    var body: some View {
        Image(member.image)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            .shadow(radius: 3)
            .rotationEffect(.degrees(rotationAngle))
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.isDragging = true
                        self.position = value.location
                        self.velocity = CGPoint(x: value.translation.width / 10, y: value.translation.height / 10)
                    }
                    .onEnded { _ in
                        self.isDragging = false
                    }
            )
            .onReceive(timer) { _ in
                guard !isDragging else { return }
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5)) {
                    position.x += velocity.x
                    position.y += velocity.y
                }
                
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                let bottomPadding: CGFloat = 230
                
                if position.x > screenWidth - 40 {
                    position.x = screenWidth - 40
                    velocity.x = -velocity.x * 0.8
                } else if position.x < 40 {
                    position.x = 40
                    velocity.x = -velocity.x * 0.8
                }
                
                if position.y > screenHeight - bottomPadding {
                    position.y = screenHeight - bottomPadding
                    velocity.y = -velocity.y * 0.8
                } else if position.y < 40 {
                    position.y = 40
                    velocity.y = -velocity.y * 0.8
                }
            }
            .onAppear {
                withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: true)) {
                    self.rotationAngle = 360
                }
            }
    }
}
#Preview {
    TeamMemberView()
}
