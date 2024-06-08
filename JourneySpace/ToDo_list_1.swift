//
//  ToDo_list_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//  Edited by Jessie on 2024/6/8

import SwiftUI
import Foundation

struct TodoPage1: View {
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .top, spacing: 15) {
                    Text("ToDo")
                        .font(.custom("KOHO", size: 96))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    VStack{
                        Spacer()
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .foregroundColor(.white)
                    }
                    .frame(height:90)
                    Spacer()
            }
                .frame(width: 350)
                Spacer()
        }
            .frame(height: 650)
    }
          .frame(width: 430, height: 932)
          .background(
            Color(red: 71/255, green: 114/255, blue: 186/255)
          )
      }
}

struct ToDo_List_1_Previews: PreviewProvider {
    static var previews: some View {
        TodoPage1()
    }
}
