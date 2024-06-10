//
//  EntryDetailView.swift
//  JourneySpace
//
//  Created by max on 2024/6/9.
//

import SwiftUI

struct EntryDetailView: View {
    var entry: DiaryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                Image(systemName: entry.emoji)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.leading)

                Spacer()
            }

            Text(entry.title)
                .font(.title)
                .bold()
                .padding(.horizontal)

            Text(entry.content)
                .font(.body)
                .padding(.horizontal)

            Spacer()
            
            Text("\(entry.date, formatter: itemFormatter)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("Emotion Detail")
    }
}

struct EntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailView(entry: DiaryEntry(title: "Sample Title", content: "Sample Content", emoji: "face.smiling", date: Date()))
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()
