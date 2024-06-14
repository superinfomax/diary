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
import SwiftData
import Foundation

struct TodoPage1: View {
    
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var toDoToEdit: ToDoItem?
    @Query(
        filter: #Predicate<ToDoItem> { $0.isCompleted == false },
        sort: \.timestamp,
        order: .forward
    ) private var items: [ToDoItem]
    
    init() {
        // 使用這個設置大標題字體
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Georgia-Bold", size: 20)!]
        
        // 使用這個設置小標題字體
        // UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Georgia-Bold", size: 20)!]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("yeloplanet")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
//                Color(red: 71/255, green: 114/255, blue: 186/255)
//                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("Image 4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .padding(.top, 50)
                    
                    List {
                        ForEach(items) { item in
                            HStack {
                                if item.isCritical {
                                    Image(systemName: "exclamationmark.3")
                                        .symbolVariant(.fill)
                                        .foregroundColor(.red)
                                        .font(.largeTitle)
                                        .bold()
                                        .padding(.trailing, 10)
                                }
                                VStack(alignment: .leading) {
                                    Text("\(item.timestamp, format: Date.FormatStyle(date: .abbreviated))")
                                        .font(.callout)
                                        .foregroundColor(.black)
                                    Text(item.title)
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Text("\(item.timestamp, format: Date.FormatStyle(time: .shortened))")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(.trailing, 10)
                                Button {
                                    withAnimation {
                                        item.isCompleted.toggle()
                                    }
                                } label: {
                                    Image(systemName: "checkmark")
                                        .symbolVariant(.circle.fill)
                                        .foregroundStyle(item.isCompleted ? .green : .gray)
                                        .font(.largeTitle)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        context.delete(item)
                                    }
                                } label: {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: "trash")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                        )
                                }
                                .tint(.red)
                                
                                Button {
                                    toDoToEdit = item
                                } label: {
                                    Circle()
                                        .fill(Color.indigo)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: "pencil")
                                                .foregroundColor(.white)
                                                .font(.system(size: 20))
                                        )
                                }
                                .tint(.indigo)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("ToDo")
                            .font(.system(size: 60))
                            .bold()
                            .foregroundColor(Color.white)
                        Button(action: {
                            showCreate.toggle()
                        }, label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.white)
                                .bold()
                        })
                    }
                }
            }
            .sheet(isPresented: $showCreate, content: {
                NavigationStack {
                    CreateToDoView()
                }
                .presentationDetents([.medium])
            })
            .sheet(item: $toDoToEdit) {
                toDoToEdit = nil
            } content: { item in
                UpdateToDoView(item: item)
            }
        }
    }
}

struct ToDo_List_1_Previews: PreviewProvider {
    static var previews: some View {
        TodoPage1()
    }
}
