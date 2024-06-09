//
//  CreateToDoView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/9.
//

import SwiftUI

struct CreateToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
@State private var item = ToDoItem()
    
    var body: some View {
        List {
            TextField("Title", text: .constant(""))
            DatePicker("Date", selection: .constant(.now))
            Toggle("Important?", isOn: .constant(false))
            Button("Create") {
                dismiss()
            }
        }
        .navigationTitle("Create ToDo")
        
    }
}
