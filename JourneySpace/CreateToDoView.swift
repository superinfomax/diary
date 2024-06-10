//
//  CreateToDoView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/9.
//

//import SwiftUI
//
//struct CreateToDoView: View {
//    
//    @Environment(\.dismiss) var dismiss
//    
//    @Binding var todos: [ToDoItem]
//    
//    @State private var item = ToDoItem()
//    
//    var body: some View {
//        List {
//            TextField("Title", text: $item.title)
//            DatePicker("Date", selection: $item.date, displayedComponents: .date)
//            Toggle("Important?", isOn: $item.isImportant)
//            Button("Create") {
//                todos.append(item)
//                dismiss()
//            }
//        }
//        .navigationTitle("Create ToDo")
//    }
//}
//
//struct CreateToDoView_Previews: PreviewProvider {
//    @State static var todos = [ToDoItem]()
//    static var previews: some View {
//        CreateToDoView(todos: $todos)
//    }
//}

import SwiftUI

struct CreateToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = ToDoItem()
    
    
    var body: some View {
        List {
            TextField("Title", text: $item.title)
            DatePicker("Date", selection: $item.timestamp)
            Toggle("Important?", isOn: $item.isCritical)
            Button("Create") {
                withAnimation {
                    context.insert(item)
                }
                dismiss()
            }
        }
        .navigationTitle("Create ToDo")
    }
}

#Preview {
    CreateToDoView()
        .modelContainer(for: ToDoItem.self)
}
