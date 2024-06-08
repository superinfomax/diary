//
//  AddEntryView.swift
//  JourneySpace
//
//  Created by max on 2024/6/7.
//

import Foundation
import SwiftUI

struct AddEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DiaryViewModel
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextEditor(text: $content)
                    .frame(height: 200)
            }
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addEntry(title: title, content: content)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}
