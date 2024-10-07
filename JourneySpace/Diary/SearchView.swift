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
            return entries.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.content.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var sortedEntries: [String: [DiaryEntry]] {
        let groupedEntries = Dictionary(grouping: filteredEntries) { entry in
            entry.title.isEmpty ? "#" : String(entry.title.prefix(1)).uppercased()
        }
        return groupedEntries.mapValues { $0.sorted { $0.title < $1.title } }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding(.top, 8)
                    .background(Color(.systemGray6))
                
                if filteredEntries.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                        Text("No Results for \"\(searchText)\"")
                            .font(.headline)
                            .truncationMode(.tail)
                            .padding(.top, 8)
                        Text("Check the spelling or try a new search.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        ForEach(sortedEntries.keys.sorted(), id: \.self) { key in
                            Section(header: Text(key).font(.headline)) {
                                ForEach(sortedEntries[key]!) { entry in
                                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                                        HStack(spacing: 12) {
                                            Image(entry.emoji)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40)
                                                .padding(8)
                                                .background(Color(UIColor.systemGray5))
                                                .clipShape(Circle())
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(entry.title)
                                                    .font(.headline)
                                                    .bold()
                                                Text(entry.content)
                                                    .font(.subheadline)
                                                    .lineLimit(nil)
                                                Text(entry.date, style: .date)
                                                    .font(.footnote)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationBarTitle("Diary Library", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(Color(red: 249/255, green: 132/255, blue: 135/255)))
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                appearance.backgroundColor = UIColor.systemGray6
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
            searchBar.resignFirstResponder()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search entries"
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = .minimal
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}
