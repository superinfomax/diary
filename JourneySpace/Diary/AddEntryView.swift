//
//  AddEntryView.swift
//  JourneySpace
//
//  Created by max on 2024/6/7.
//
// AddEntryView.swift
//  豆沙色號 .background(Color(red: 237/255, green: 156/255, blue: 149/255))
import Foundation
import SwiftUI

struct AddEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DiaryViewModel
    
    @State private var date = Date()
    @State private var content = ""
    @State private var currentEmoji = "happy" // 默認使用自定義圖片
    @State private var title = ""
    @State private var showEmojiPicker = false
    
    let emojis = ["happy", "sad", "angry", "confuse", "nowords", "tired", "sleepy", "love", "nervous"]
    
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
                    viewModel.addEntry(title: title, content: content, emoji: currentEmoji)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
//                        .background(Color.blue)
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

struct EmojiPicker: View {
    @Binding var currentEmoji: String
    var onEmojiSelected: () -> Void
    
    let emojis = ["happy", "sad", "angry", "confuse", "nowords", "tired", "sleepy", "love", "nervous"]
    
    let columns = [
        GridItem(.flexible(), spacing: 30), // 設置橫向間距
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible(), spacing: 30)
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 10) { // 縱向間距
                ForEach(emojis, id: \.self) { emoji in
                    Button(action: {
                        currentEmoji = emoji
                        onEmojiSelected()
                    }) {
                        Image(emoji)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding()
                    }
                }
            }
            .padding()
        }
        .frame(width: 250, height: 250) // 調整彈出窗口的大小
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView(viewModel: DiaryViewModel())
    }
}
