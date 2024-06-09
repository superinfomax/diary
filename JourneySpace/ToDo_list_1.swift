//
//  ToDo_list_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//  Edited by Jessie on 2024/6/8

import SwiftUI
import Foundation

struct TodoPage1: View {
    
    @State private var showCreate = false
    
    var body: some View {
        ZStack {
            Color(red: 71/255, green: 114/255, blue: 186/255)
                .edgesIgnoringSafeArea(.all)
            NavigationStack {
                Text("ToDo")
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                showCreate.toggle()
                            }, label: {
                                Label("Add Item", systemImage: "plus")
                            })
                        }
                    }
                    .sheet(isPresented: $showCreate,
                           content: {
                        NavigationStack {
                            CreateToDoView()
                        }
                    })
            }
        }
    }
}

struct ToDo_List_1_Previews: PreviewProvider {
    static var previews: some View {
        TodoPage1()
    }
}
