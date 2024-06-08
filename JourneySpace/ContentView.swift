//
//  JourneySpaceApp.swift
//  JourneySpace
//
//  Created by max on 2024/5/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DiaryViewModel()
    @State private var showingAddEntryView = false
    private var currentDateComponents: (String, String, String) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM"
        let monthDate = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "EE"
        let dayOfWeek = dateFormatter.string(from: Date())
        
        return (monthDate, day, dayOfWeek)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.entries) { entry in
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
                .onDelete(perform: viewModel.deleteEntry)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Text(currentDateComponents.0)
                            .font(.custom("KOHO", size: 42))
                            .foregroundColor(.white)
                        HStack {
                            Text(currentDateComponents.1)
                                .font(.custom("KOHO", size: 42))
                                .foregroundColor(.white)
                            Text(currentDateComponents.2)
                                .font(.custom("KOHO", size: 15))
                                .foregroundColor(.white)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack {
                        Button(action: {
                            showingAddEntryView.toggle()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom)
                    }
                }
            }
            .sheet(isPresented: $showingAddEntryView) {
                AddEntryView(viewModel: viewModel)
            }
            .background(Color(red: 237/255, green: 156/255, blue: 149/255))
        }
        .onAppear {
            viewModel.loadEntries()
        }
    }
}
