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
    
    @State private var date = Date()
    @State private var content = ""
    @State private var currentEmoji = "face.smiling"
    @State private var title = ""
    @State private var showEmojiPicker = false
    
    let emojis = ["face.smiling", "face.smiling.inverse", "face.dashed", "face.dashed.fill", "die.face.1", "die.face.2", "die.face.3", "die.face.4"]
    
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
                
                Text(dateFormatted(date: date))
                    .font(.custom("Marker Felt", size: 36))
                    .padding(.horizontal)
                
                Button(action: {
                    showEmojiPicker.toggle()
                }) {
                    Image(systemName: currentEmoji)
                        .resizable()
                        .frame(width: 40, height: 40)
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
                    viewModel.addEntry(title: title, content: content, emoji: currentEmoji)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
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

struct EmojiPicker: View {
    @Binding var currentEmoji: String
    var onEmojiSelected: () -> Void
    
    let emojis = ["face.smiling", "face.smiling.inverse", "face.dashed", "face.dashed.fill", "die.face.1", "die.face.2", "die.face.3", "die.face.4"]
    
    let columns = [
        GridItem(.adaptive(minimum: 60))
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(emojis, id: \.self) { emoji in
                    Button(action: {
                        currentEmoji = emoji
                        onEmojiSelected()
                    }) {
                        Image(systemName: emoji)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                    }
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200)
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView(viewModel: DiaryViewModel())
    }
}
