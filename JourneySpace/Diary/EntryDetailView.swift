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
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(entry.emoji) // 使用 entry.emoji 來顯示自定義圖片
                    .resizable()
                    .frame(width: 70, height: 70) // 調整圖片大小
                    .padding(.leading)
                    .padding(.top, 25)
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
        //.navigationTitle("Emotion Detail")
    }
}

struct EntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EntryDetailView(entry: DiaryEntry(title: "Sample Title", content: "Sample Content", emoji: "happy", date: Date()))
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    var vibrancyStyle: UIVibrancyEffectStyle? = nil

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}
