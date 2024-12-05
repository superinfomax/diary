//
//  EditEntryView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/12/5.
//

import SwiftUI

struct EditEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DiaryViewModel
    let entry: DiaryEntry
    
    @State private var title: String
    @State private var content: String
    @State private var currentEmoji: String
    @State private var showEmojiPicker = false
    
    init(viewModel: DiaryViewModel, entry: DiaryEntry) {
        self.viewModel = viewModel
        self.entry = entry
        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
        _currentEmoji = State(initialValue: entry.emoji)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding()
                
                Text(dateFormatted(date: entry.date))
                    .font(.custom("Marker Felt", size: 36))
                    .padding(.horizontal)
                
                Button(action: {
                    showEmojiPicker.toggle()
                }) {
                    Image(currentEmoji)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(.horizontal)
                }
                .popover(isPresented: $showEmojiPicker) {
                    EmojiPicker(currentEmoji: $currentEmoji) {
                        showEmojiPicker = false
                    }
                }
                
                TextField("Title", text: $title)
                    .font(.custom("Marker Felt", size: 24))
                    .padding(.horizontal)
                
                TextEditor(text: $content)
                    .frame(height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    viewModel.editEntry(entry: entry, newTitle: title, newContent: content, newEmoji: currentEmoji)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 249/255, green: 132/255, blue: 135/255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(title.isEmpty || content.isEmpty)
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarHidden(true)
        }
    }

    func dateFormatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd"
        return formatter.string(from: date)
    }
}

//#Preview {
//    EditEntryView()
//}
