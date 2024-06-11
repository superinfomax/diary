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
            //Use this if NavigationBarTitle is with Large Font
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]

            //Use this if NavigationBarTitle is with displayMode = .inline
            //UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
        }
    
    
    
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
//                            Text("\(item.timestamp, format: Date.FormatStyle(date: .abbreviated, time: .shortened))")
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .abbreviated))")
                                .font(.callout)
                            
                            Text(item.title)
                                .font(.largeTitle)
                                .bold()
                        }
                        Spacer()
                        
                        Text("\(item.timestamp, format: Date.FormatStyle(time: .shortened))")
                            .font(.title)
                            .bold()
                            
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
                        .tint(.indigo)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 71/255, green: 114/255, blue: 186/255))
//            .navigationBarTitle(Text("To Do").font(.subheadline), displayMode: .large)
//            Text("")
//                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("ToDo")
                                    .offset(y:20)
                                    .padding()
                                    .font(.system(size: 50))
                                    .bold()
                                    .foregroundColor(Color.white)
                                    .background(.clear)
                                    .frame(height:300)
                                Spacer()
                            }
                        }
                    }
            
            
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showCreate.toggle()
                    }, label: {
//                        Label("Add Item", systemImage: "plus")
                        Image(systemName: "plus.circle")
                                        .foregroundColor(.white)
                                        .bold()
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

//struct ToDo_List_1_Previews: PreviewProvider {
//    static var previews: some View {
//        TodoPage1()
//    }
//}
