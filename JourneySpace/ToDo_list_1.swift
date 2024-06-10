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
    @Query(filter: #Predicate { $0.isCompleted == false)private var items: [ToDoItem]
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            if item.isCritical {
                                Image(systemName: "exclamationmark.3")
                                    .symbolVariant(.fill)
                                    .foregroundColor(.red)
                                    .font(.largeTitle)
                                    .bold()
                                
                            }
                            Text(item.title)
                                .font(.largeTitle)
                                .bold()
                            
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .abbreviated, time: .shortened))")
                                .font(.callout)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation{
                                item.isCompleted.toggle()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .symbolVariant(.circle.fill)
                                .foregroundStyle(item.isCompleted ? .green :.gray)
                                .font(.largeTitle)
                        }
                        .buttonStyle(.plain)
                        
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                context.delete(item)
                            }
                        }label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }
                        Button{
                            toDoToEdit = item
                        }label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle("ToDo")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showCreate.toggle()
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
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
            }content: { item in
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
