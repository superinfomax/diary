//
//  ToDo_list_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//  Edited by Jessie on 2024/6/8

//import SwiftUI
//
//struct TodoPage1: View {
//    
//    @State private var showCreate = false
//    @State private var todos = [ToDoItem]()
//    
//    var body: some View {
//        ZStack {
//            Color(red: 71/255, green: 114/255, blue: 186/255)
//                .edgesIgnoringSafeArea(.all)
//            NavigationStack {
//                VStack {
//                    Text("ToDo")
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                    
//                    List {
//                        ForEach(todos) { todo in
//                            VStack(alignment: .leading) {
//                                Text(todo.title)
//                                    .font(.headline)
//                                Text("\(todo.date, formatter: DateFormatter.shortDate)")
//                                    .font(.subheadline)
//                                if todo.isImportant {
//                                    Text("Important")
//                                        .foregroundColor(.red)
//                                }
//                            }
//                        }
//                    }
//                    .background(Color.white)
//                }
//                .toolbar {
//                    ToolbarItem {
//                        Button(action: {
//                            showCreate.toggle()
//                        }, label: {
//                            Label("Add Item", systemImage: "plus")
//                        })
//                    }
//                }
//                .sheet(isPresented: $showCreate,
//                       content: {
//                    NavigationStack {
//                        CreateToDoView(todos: $todos)
//                    }
//                })
//            }
//        }
//    }
//}
//
//struct ToDo_List_1_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoPage1()
//    }
//}
//extension DateFormatter {
//    static var shortDate: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        return formatter
//    }
//}
//


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
