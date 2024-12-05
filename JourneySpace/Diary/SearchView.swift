//
//  SearchView.swift
//  JourneySpace
//
//  Created by max on 2024/6/9.
//

import SwiftUI

struct SearchView: View {
    let entries: [DiaryEntry]
    let viewModel: DiaryViewModel
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode

    var filteredEntries: [DiaryEntry] {
        guard !searchText.isEmpty else { return entries }
        return entries.filter { entry in
            let titleMatch = entry.title.localizedCaseInsensitiveContains(searchText)
            let contentMatch = entry.content.localizedCaseInsensitiveContains(searchText)
            return titleMatch || contentMatch
        }
    }
    
    var sortedEntries: [String: [DiaryEntry]] {
        // 第一步：按首字母分組
        let grouped = Dictionary(grouping: filteredEntries) { entry -> String in
            if entry.title.isEmpty {
                return "#"
            }
            let firstChar = String(entry.title.prefix(1))
            return firstChar.uppercased()
        }
        
        // 第二步：對每個組內的條目進行排序
        let sorted = grouped.mapValues { entries -> [DiaryEntry] in
            return entries.sorted { $0.title < $1.title }
        }
        
        return sorted
    }

    var body: some View {
        NavigationStack {
            mainContent
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            searchBarSection
            
            if filteredEntries.isEmpty {
                emptyResultsView
            } else {
                entriesList
            }
        }
        .navigationBarTitle("Diary Library", displayMode: .inline)
        .navigationBarItems(trailing: doneButton)
        .onAppear(perform: configureNavigationBar)
    }
    
    private var searchBarSection: some View {
        SearchBar(text: $searchText)
            .padding(.top, 8)
            .background(Color(.systemGray6))
    }
    
    private var emptyResultsView: some View {
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
    }
    
    private var entriesList: some View {
        // 將 List 內容分離出來
        let content = ForEach(sortedEntries.keys.sorted(), id: \.self) { key in
            Section {
                // 將 Section 內容分離出來
                let entries = sortedEntries[key] ?? []
                ForEach(entries) { entry in
                    NavigationLink {
                        // 這裡我們需要傳入 viewModel 參數
                        EntryDetailView(entry: entry, viewModel: viewModel)
                    } label: {
                        EntryRowView(entry: entry)
                    }
                }
            } header: {
                Text(key)
                    .font(.headline)
            }
        }

        return List {
            content
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    private var doneButton: some View {
        Button("Done") {
            presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(Color(red: 249/255, green: 132/255, blue: 135/255))
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = UIColor.systemGray6
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

// 將 EntryRow 抽出來作為獨立的 View 結構
private struct EntryRowView: View {
    let entry: DiaryEntry
    
    var body: some View {
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
                    .lineLimit(2)
                Text(entry.date, style: .date)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
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
