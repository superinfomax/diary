//
//  JourneySpaceApp.swift
//  JourneySpace
//
//  Created by max on 2024/5/26.
//

//import SwiftUI
//
//struct ContentView: View {
//    
//    @StateObject private var viewModel = DiaryViewModel()
//    @State private var showingAddEntryView = false
//    
//    private var currentDateComponents: (String, String, String) {
//        let dateFormatter = DateFormatter()
//        
//        dateFormatter.dateFormat = "MMMM"
//        let monthDate = dateFormatter.string(from: Date())
//        
//        dateFormatter.dateFormat = "dd"
//        let day = dateFormatter.string(from: Date())
//    
//        dateFormatter.dateFormat = "EE"
//        let dayOfWeek = dateFormatter.string(from: Date())
//        
//        return (monthDate, day, dayOfWeek)
//    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color(red: 237/255, green: 156/255, blue: 149/255)
//                    .edgesIgnoringSafeArea(.all)
//                VStack {
//                    VStack(alignment: .leading) {
//                        Text(currentDateComponents.0)
//                            .font(.custom("KOHO", size: 42))
//                            .foregroundColor(.white)
//                        HStack {
//                            Text(currentDateComponents.1)
//                                .font(.custom("KOHO", size: 42))
//                                .foregroundColor(.white)
//                            Text(currentDateComponents.2)
//                                .font(.custom("KOHO", size: 15))
//                                .foregroundColor(.white)
//                        }
//                    }
//                    .padding(.top, 40)
//                    Spacer()
//                    List {
//                        ForEach(viewModel.entries) { entry in
//                            NavigationLink(destination: EntryDetailView(entry: entry)) {
//                                VStack(alignment: .leading, spacing: 8) {
//                                    Text(entry.title)
//                                        .font(.headline)
//                                    Text(entry.content)
//                                        .font(.subheadline)
//                                        .lineLimit(2)
//                                    Text(entry.date, style: .date)
//                                        .font(.footnote)
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                        .onDelete(perform: viewModel.deleteEntry)
//                    }
//                    .listStyle(PlainListStyle())
//                    .background(Color.clear)
//                    .cornerRadius(20)
//                    .padding(.horizontal)
//                    Spacer()
//                    HStack {
//                        Spacer()
//                    }
//                    .padding(.bottom, 20)
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        showingAddEntryView.toggle()
//                    }) {
//                        Image(systemName: "doc.fill.badge.plus")
//                            .font(.system(size: 24))
//                            .foregroundColor(.white)
//                    }
//                }
//            }
//            .sheet(isPresented: $showingAddEntryView) {
//                AddEntryView(viewModel: viewModel)
//            }
//            .onAppear {
//                viewModel.loadEntries()
//            }
//        }
//    }
//}
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = DiaryViewModel()
    @State private var showingAddEntryView = false
    @State private var showingSearchView = false
    
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
                Color(red: 237/255, green: 156/255, blue: 149/255)
                    .edgesIgnoringSafeArea(.all)
                VStack {
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
                    List {
                        ForEach(viewModel.entries) { entry in
                            NavigationLink(destination: EntryDetailView(entry: entry)) {
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
                        .onDelete(perform: viewModel.deleteEntry)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    Spacer()
                    HStack {
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingSearchView.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
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
            .fullScreenCover(isPresented: $showingSearchView) {
                SearchView(entries: viewModel.entries)
            }
            .onAppear {
                viewModel.loadEntries()
            }
        }
    }
}
