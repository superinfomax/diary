//
//  ToDo_history.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/24.
//

import SwiftUI
import SwiftData
import Foundation

struct ToDo_history: View {
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var toDoToEdit: ToDoItem?
    @Query(
        filter: #Predicate<ToDoItem> { $0.isCompleted == true },
        sort: \.timestamp,
        order: .forward
    ) private var items: [ToDoItem]
    
    @State private var currentImage: String = "eatTrashYelo"
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.setBackIndicatorImage(UIImage(systemName: "chevron.backward"),
                                         transitionMaskImage: UIImage(systemName: "chevron.backward"))
        UINavigationBar.appearance().tintColor = .white
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor:UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            Image("todo_HistoryBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                List {
                    ForEach(sortedItems) { item in
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
                        
                        .swipeActions(edge: .leading) {
                            Button(role: .destructive) {
                                withAnimation {
                                    item.isCompleted.toggle()
                                    Task {
                                        await item.updateReminder()
                                    }
                                }
                            } label: {
                                Image(uiImage: UIImage(systemName: "arrowshape.turn.up.backward.badge.clock.fill")!.withTintColor(.gray, renderingMode: .alwaysOriginal))
                            }
                            .tint(.clear)
                        }
                        
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                Task {
                                    await item.deleteReminder()
                                    context.delete(item)
                                }
                            } label: {
                                Label("刪除", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(.vertical, -2)
                }
                .listStyle(PlainListStyle())
                
                Spacer()
                
                Image(currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    currentImage = "confuseYelo"
                }
                
                Task {
                    do {
                        let granted = try await RemindersManager.shared.requestAccess()
                        if granted {
                            print("Reminders access granted")
                        } else {
                            print("Reminders access denied")
                        }
                    } catch {
                        print("Error requesting Reminders access: \(error)")
                    }
                }
            }
        }
    }
    
    private var sortedItems: [ToDoItem] {
        items.sorted {
            if $0.isCritical != $1.isCritical {
                return $0.isCritical && !$1.isCritical
            }
            return $0.timestamp < $1.timestamp
        }
    }
}
