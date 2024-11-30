//
//  ToDo_list_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//  Edited by Jessie on 2024/6/8
//  藍色色碼    .background(Color(red: 71/255, green: 114/255, blue: 186/255))

import SwiftUI
import SwiftData
import Foundation
import EventKit

struct TodoPage1: View {
    @Environment(\.modelContext) var context
    @State private var showCreate = false
    @State private var toDoToEdit: ToDoItem?
    
    @Query private var items: [ToDoItem]
    
    init() {
        let predicate = #Predicate<ToDoItem> { item in
            !item.isCompleted
        }
        _items = Query(filter: predicate, sort: \ToDoItem.timestamp)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont(name: "Georgia-Bold", size: 20)!
        ]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("yeloplanet")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    Image("Image 4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                    
                    List {
                        ForEach(sortedItems) { item in
                            TodoItemRow(item: item, toDoToEdit: $toDoToEdit, context: context)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, -3)
                    }
                    .offset(y: -20)
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
                            .foregroundColor(.clear)
                            .offset(y: 10)
                        
                        Button {
                            showCreate.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.white)
                                .bold()
                                .offset(y: 10)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            ToDo_history()
                        } label: {
                            Image(systemName: "text.book.closed.fill")
                                .foregroundColor(.white)
                                .bold()
                                .offset(y: 10)
                                .padding(.leading, 110)
                        }
                    }
                }
            }
            .overlay(alignment: .topLeading) {
                Text("ToDo")
                    .font(.system(size: 60))
                    .bold()
                    .foregroundColor(.white)
                    .offset(y: 10)
                    .padding(.leading, 20)
            }
        }
        .sheet(isPresented: $showCreate) {
            NavigationStack {
                CreateToDoView()
            }
            .presentationDetents([.large])
        }
        .sheet(item: $toDoToEdit) {
            toDoToEdit = nil
        } content: { item in
            UpdateToDoView(item: item)
        }
        .onAppear {
            RemindersObserver.shared.startObserving(with: context)
        }
    }
    
    private var sortedItems: [ToDoItem] {
        items.sorted { item1, item2 in
            guard item1.isCritical == item2.isCritical else {
                return item1.isCritical && !item2.isCritical
            }
            return item1.timestamp < item2.timestamp
        }
    }
}

struct TodoItemRow: View {
    let item: ToDoItem
    @Binding var toDoToEdit: ToDoItem?
    let context: ModelContext
    
    private func deleteItem() async {
        await item.deleteReminder()
        await MainActor.run {
            context.delete(item)
        }
    }
    
    private func toggleCompletion() async {
        await MainActor.run {
            item.isCompleted.toggle()
        }
        await item.updateReminder()
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(item.timestamp, format: Date.FormatStyle(date: .abbreviated))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                if item.isCritical {
                    Image(systemName: "exclamationmark.2")
                        .symbolVariant(.fill)
                        .foregroundColor(.red)
                        .font(.title)
                        .bold()
                        .padding(.trailing)
                }
                
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
                .padding()
        }
        .frame(width: 340)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                Task {
                    await deleteItem()
                }
            } label: {
                Image("trashCan_icon_ToDo")
            }
            .tint(.clear)
            
            Button {
                toDoToEdit = item
            } label: {
                Image("edit_icon_ToDo")
            }
            .tint(.clear)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                Task {
                    await toggleCompletion()
                }
            } label: {
                Image(uiImage: UIImage(systemName: "checkmark.circle.fill")!
                    .withTintColor(.green, renderingMode: .alwaysOriginal))
            }
            .tint(.clear)
        }
    }
}

#Preview {
    TodoPage1()
}
