//
//  JourneySpaceApp.swift
//  JourneySpace
//
//  Created by max on 2024/5/26.
//

import SwiftUI
import Foundation
struct ContentView: View {
    @StateObject private var viewModel = DiaryViewModel()
    @State private var showingAddEntryView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.entries) { entry in
                    VStack(alignment: .leading) {
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
                .onDelete(perform: viewModel.deleteEntry)
            }
            .navigationTitle("Diary")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddEntryView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEntryView) {
                AddEntryView(viewModel: viewModel)
            }
        }
        .onAppear {
            viewModel.loadEntries()
        }
    }
}
