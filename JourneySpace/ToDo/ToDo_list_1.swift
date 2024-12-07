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
    @State private var isRefreshing = false
    private let calendarManager = GoogleCalendarManager.shared
    
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
//    private func refreshTodoItems() async {
//        let now = Date()
//        let threeMonthsLater = Calendar.current.date(byAdding: .month, value: 3, to: now) ?? now
//        
//        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
//            calendarManager.fetchEvents(from: now, to: threeMonthsLater) { result in
//                switch result {
//                case .success(let calendarEvents):
//                    Task { @MainActor in
//                        // 獲取現有的待辦事項
//                        let descriptor = FetchDescriptor<ToDoItem>(
//                            predicate: #Predicate<ToDoItem> { !$0.isCompleted }
//                        )
//                        guard let existingItems = try? context.fetch(descriptor) else { return }
//                        
//                        // 建立一個用於檢查重複的函數
//                        func isDuplicate(title: String, timestamp: Date, items: [ToDoItem]) -> Bool {
//                            return items.contains { item in
//                                let sameTitle = item.title == title
//                                let sameTime = abs(item.timestamp.timeIntervalSince(timestamp)) < 60 // 允許1分鐘的誤差
//                                return sameTitle && sameTime
//                            }
//                        }
//                        
//                        // 刪除所有本地待辦事項中，在 Google Calendar 不存在的事項
//                        for item in existingItems {
//                            let exists = calendarEvents.contains { event in
//                                event.id == item.getGoogleEventId() ||
//                                (event.title == item.title &&
//                                 abs(event.startDate.timeIntervalSince(item.timestamp)) < 60)
//                            }
//                            if !exists {
//                                context.delete(item)
//                            }
//                        }
//                        
//                        // 新增或更新 Google Calendar 事項
//                        for event in calendarEvents {
//                            if let existingItem = existingItems.first(where: { $0.getGoogleEventId() == event.id }) {
//                                // 更新現有事項
//                                existingItem.title = event.title
//                                existingItem.timestamp = event.startDate
//                            } else if !isDuplicate(title: event.title, timestamp: event.startDate, items: existingItems) {
//                                // 只有在不重複的情況下才新增
//                                let newItem = ToDoItem(
//                                    title: event.title,
//                                    timestamp: event.startDate,
//                                    isCritical: false,
//                                    isCompleted: false
//                                )
//                                newItem.setGoogleEventId(event.id)
//                                context.insert(newItem)
//                            }
//                        }
//                        
//                        try? context.save()
//                    }
//                case .failure(let error):
//                    print("Failed to fetch events: \(error)")
//                }
//                continuation.resume()
//            }
//        }
//    }
    private func refreshTodoItems() async {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startTime = min(startOfToday, ToDoItem.firstGoogleLinkTime ?? startOfToday)
        let endTime = calendar.date(byAdding: .year, value: 1, to: Date()) ?? Date()

        do {
            let events = try await calendarManager.fetchEvents(from: startTime, to: endTime)
            
            await MainActor.run {
                let descriptor = FetchDescriptor<ToDoItem>(
                    predicate: #Predicate<ToDoItem> { !$0.isCompleted }
                )
                guard let existingItems = try? context.fetch(descriptor) else { return }
                
                var itemsMap: [String: ToDoItem] = [:]
                for item in existingItems {
                    if let eventId = item.getGoogleEventId() {
                        itemsMap[eventId] = item
                    }
                }
                
                for event in events where !event.isCompleted {
                    if let existingItem = itemsMap[event.id] {
                        existingItem.title = event.title
                        existingItem.timestamp = event.startDate
                    } else {
                        let newItem = ToDoItem(
                            title: event.title,
                            timestamp: event.startDate,
                            isCritical: false,
                            isCompleted: false
                        )
                        newItem.setGoogleEventId(event.id)
                        context.insert(newItem)
                    }
                }
                
                let validEventIds = Set(events.map { $0.id })
                for item in existingItems {
                    if let eventId = item.getGoogleEventId(),
                       !validEventIds.contains(eventId) {
                        context.delete(item)
                    }
                }
                
                try? context.save()
            }
        } catch {
            print("Failed to sync with Google Calendar: \(error)")
        }
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
                        .frame(height: 180)
                    
                    List {
                        ForEach(sortedItems) { item in
                            TodoItemRow(item: item, toDoToEdit: $toDoToEdit, context: context)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, -3)
                    }
                    .refreshable {
                        await refreshTodoItems()
                    }
                    .offset(y: -20)
                    .listStyle(PlainListStyle())
//                    .cornerRadius(20)
                }
                .padding(.bottom, 60)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("ToDo")
                            .font(.system(size: 60))
                            .bold()
                            .foregroundColor(.clear)
                            .offset(y: -10)
                        
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
                    .offset(y: -50)
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
            Task {
                await refreshTodoItems()
            }
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
    @Environment(\.modelContext) var modelContext
    let item: ToDoItem
    @Binding var toDoToEdit: ToDoItem?
    let context: ModelContext
    @State private var isDeleting = false
    private let calendarManager = GoogleCalendarManager.shared
    
    private func deleteItem() async {
        isDeleting = true
        
        // 先刪除 Google Calendar 事件
        if let googleEventId = item.getGoogleEventId() {
            await withCheckedContinuation { continuation in
                calendarManager.deleteEventForToDo(item) { result in
                    switch result {
                    case .success:
                        print("Successfully deleted Google Calendar event")
                    case .failure(let error):
                        print("Failed to delete Google Calendar event: \(error)")
                    }
                    continuation.resume()
                }
            }
        }
        
        // 然後刪除 Reminder
        await item.deleteReminder()
        
        // 最後刪除本地待辦事項
        await MainActor.run {
            context.delete(item)
            try? modelContext.save() // 立即儲存變更
            isDeleting = false
        }
    }
    
    private func toggleCompletion() async {
        await MainActor.run {
            item.isCompleted = true
            // 確保取消通知
            item.cancelScheduledNotification()
            try? modelContext.save()
        }
        
        // 更新 Google Calendar 事件的 description
        if let eventId = item.getGoogleEventId() {
            await withCheckedContinuation { continuation in
                calendarManager.updateEventDescription(eventId: eventId, description: "completed") { result in
                    switch result {
                    case .success:
                        print("Successfully marked event as completed")
                    case .failure(let error):
                        print("Failed to mark event as completed: \(error)")
                    }
                    continuation.resume()
                }
            }
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
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .overlay(
            isDeleting ?
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
                .background(Color.black.opacity(0.2))
            : nil
        )
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
