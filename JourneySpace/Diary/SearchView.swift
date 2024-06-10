//
//  SearchView.swift
//  JourneySpace
//
//  Created by max on 2024/6/9.
//

import SwiftUI

struct SearchView: View {
    let entries: [DiaryEntry]
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode

    var filteredEntries: [DiaryEntry] {
        if searchText.isEmpty {
            return entries
        } else {
            return entries.filter { $0.title.contains(searchText) || $0.content.contains(searchText) }
        }
    }
    
    var sortedEntries: [String: [DiaryEntry]] {
        let groupedEntries = Dictionary(grouping: filteredEntries) { entry in
            String(entry.title.prefix(1)).uppercased()
        }
        return groupedEntries.mapValues { $0.sorted { $0.title < $1.title } }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                List {
                    ForEach(sortedEntries.keys.sorted(), id: \.self) { key in
                        Section(header: Text(key).font(.headline)) {
                            ForEach(sortedEntries[key]!) { entry in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(entry.title)
                                        .font(.headline)
                                    Text(entry.content)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                    Text(entry.date, style: .date)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Diary Library", displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search entries"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}
