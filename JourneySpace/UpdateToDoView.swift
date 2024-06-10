//
//  UpdateToDoView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/10.
//

import SwiftUI
import SwiftData

struct UpdateToDoView: View {
    @Environment(\.dismiss) var dismiss
    
    @Bindable var item: ToDoItem
    
    var body: some View {
        List {
            TextField("Title", text: $item.title)
            DatePicker("Date", selection: $item.timestamp)
            Toggle("Important?", isOn: $item.isCritical)
            Button("Update") {
                dismiss()
            }
        }
        .navigationTitle("Update ToDo")
    }
}

//#Preview {
//    UpdateToDoView()
//}
