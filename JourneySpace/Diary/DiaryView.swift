//
//  SearchView.swift
//  JourneySpace
//
//  Created by max on 2024/6/9.
//

import SwiftUI

struct DiaryView: View {
    
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
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(currentDateComponents.0)
                                .font(.custom("KOHO", size: 42))
                                .foregroundColor(.white)
                            HStack(alignment: .bottom) {
                                Text(currentDateComponents.1)
                                    .font(.custom("KOHO", size: 42))
                                    .foregroundColor(.white)
                                    .alignmentGuide(.bottom) { d in d[.lastTextBaseline] }
                                Text(currentDateComponents.2)
                                    .font(.custom("KOHO", size: 17))
                                    .foregroundColor(.white)
                                    .alignmentGuide(.bottom) { d in d[.lastTextBaseline] }
                            }
                        }
                        Spacer()
                        Button(action: {
                            showingAddEntryView.toggle()
                        }) {
                            Image("Image 6")
                                .resizable()
                                .scaledToFit()
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        }
                        .alignmentGuide(.bottom) { d in d[.lastTextBaseline] }
                    }
                    .padding(.horizontal, 30)
                    //.padding(.top, 40)
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
//                    ToolbarItem(placement: .principal) {
//                        Image("Image 6")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 100)
//                    }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}


//struct ContentView: View {
//
//    @StateObject private var viewModel = DiaryViewModel()
//    @State private var showingAddEntryView = false
//    @State private var showingSearchView = false
//
//    private var currentDateComponents: (String, String, String) {
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateFormat = "MMMM"
//        let monthDate = dateFormatter.string(from: Date())
//
//        dateFormatter.dateFormat = "yyyy"
//        let year = dateFormatter.string(from: Date())
//
//        return (year, monthDate, "")
//    }
//
//    let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//    ]
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.white
//                    .edgesIgnoringSafeArea(.all)
//
//                VStack {
//                    HStack {
//                        Button(action: {
//                            showingSearchView.toggle()
//                        }) {
//                            Image(systemName: "ladybug")
//                                .font(.system(size: 24))
//                                .foregroundColor(.black)
//                        }
//
//                        Spacer()
//
//                        VStack {
//                            Text(currentDateComponents.0)
//                                .font(.custom("KOHO", size: 20))
//                                .foregroundColor(.black)
//
//                            Text(currentDateComponents.1)
//                                .font(.custom("KOHO", size: 32))
//                                .foregroundColor(.black)
//                                .padding(.bottom, 5)
//                        }
//
//                        Spacer()
//
//                        Button(action: {
//                            showingAddEntryView.toggle()
//                        }) {
//                            Image(systemName: "camera")
//                                .font(.system(size: 24))
//                                .foregroundColor(.black)
//                        }
//                    }
//                    .padding()
//
//                    ScrollView {
//                        VStack {
//                            ForEach(getMonthsData(), id: \.self) { monthData in
//                                VStack {
//                                    Text(monthData.monthName)
//                                        .font(.custom("KOHO", size: 32))
//                                        .padding(.vertical, 10)
//
//                                    LazyVGrid(columns: columns, spacing: 20) {
//                                        ForEach(1...monthData.daysCount, id: \.self) { day in
//                                            ZStack {
//                                                Circle()
//                                                    .stroke(Color.black, lineWidth: 2)
//                                                    .frame(width: 50, height: 50)
//
//                                                if let entry = viewModel.entries.first(where: { Calendar.current.isDate($0.date, equalTo: monthData.firstDate.addingTimeInterval(TimeInterval((day - 1) * 86400)), toGranularity: .day) }) {
//                                                    NavigationLink(destination: EntryDetailView(entry: entry)) {
//                                                        Image(systemName: entry.emoji)
//                                                            .resizable()
//                                                            .frame(width: 40, height: 40)
//                                                            .foregroundColor(.purple)
//                                                    }
//                                                } else if Calendar.current.isDateInToday(monthData.firstDate.addingTimeInterval(TimeInterval((day - 1) * 86400))) {
//                                                    Text("\(day)")
//                                                        .foregroundColor(.red)
//                                                } else {
//                                                    Text("\(day)")
//                                                        .foregroundColor(.black)
//                                                }
//                                            }
//                                        }
//                                    }
//                                    .padding(.horizontal, 10)
//                                }
//                            }
//                        }
//                    }
//
//                    Spacer()
//                }
//            }
//            .sheet(isPresented: $showingAddEntryView) {
//                AddEntryView(viewModel: viewModel)
//            }
//            .fullScreenCover(isPresented: $showingSearchView) {
//                SearchView(entries: viewModel.entries)
//            }
//            .onAppear {
//                viewModel.loadEntries()
//            }
//        }
//    }
//
//    private func getMonthsData() -> [MonthData] {
//        let calendar = Calendar.current
//        let today = Date()
//        var monthsData: [MonthData] = []
//
//        // Start from the current month and go back to January 1970
//        var date = today
//        while date > calendar.date(from: DateComponents(year: 1970, month: 1))! {
//            let month = calendar.component(.month, from: date)
//            let year = calendar.component(.year, from: date)
//            let range = calendar.range(of: .day, in: .month, for: date)!
//            let numDays = range.count
//
//            let monthName = DateFormatter().monthSymbols[month - 1]
//            monthsData.append(MonthData(monthName: "\(monthName) \(year)", daysCount: numDays, firstDate: calendar.date(from: calendar.dateComponents([.year, .month], from: date))!))
//
//            // Move to the previous month
//            date = calendar.date(byAdding: .month, value: -1, to: date)!
//        }
//
//        return monthsData
//    }
//}
//
//struct MonthData: Hashable {
//    let monthName: String
//    let daysCount: Int
//    let firstDate: Date
//}
