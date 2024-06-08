//
//  mainview.swift
//  JourneySpace
//
//  Created by max on 2024/6/7.
//

import SwiftUI
import Foundation
struct LoginView: View {
    @State private var showMenuView = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Journal")
                .font(.custom("KOHO", size: 85))
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Space")
                .font(.custom("KOHO", size: 85))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                showMenuView = true
            }) {
                Text("Depart")
                    .font(.custom("KOHO", size: 42))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 127/255, green: 125/255, blue: 183/255))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            
            .fullScreenCover(isPresented: $showMenuView) {
                MenuView()
            }
            
            Spacer()
        }
        .background(Color(red: 82/255, green: 78/255, blue: 124/255).edgesIgnoringSafeArea(.all))
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
