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
            ZStack {
                // Background color
                Color(red: 237/255, green: 156/255, blue: 149/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header with date
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
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // List of diary entries
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
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Bottom Characters
                    HStack {
                        Spacer()
//                        VStack {
//                            Image(systemName: "character.smiling") // Placeholder for character image
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                                .clipShape(Circle())
//                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddEntryView.toggle()
                    }) {
                        Image(systemName: "doc.fill.badge.plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingAddEntryView) {
                AddEntryView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadEntries()
            }
        }
    }
}
