//
//  ToDo_history.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/24.
//

import SwiftUI
import SwiftData
import Foundation

struct ToDo_history: View {
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var toDoToEdit: ToDoItem?
    @Query(
        filter: #Predicate<ToDoItem> { $0.isCompleted == true },
        sort: \.timestamp,
        order: .forward
    ) private var items: [ToDoItem]
    
    var body: some View {
        List {
            ForEach(sortedItems) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(item.timestamp, format: Date.FormatStyle(date: .abbreviated))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            
                        if item.isCritical {
                            Image(systemName: "exclamationmark.2")
                                .symbolVariant(.fill)
                                .foregroundColor(.red)
                                .font(.title)
                                .bold()
                                .padding(.trailing)
                        }
                        
                        Text(item.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                        
                    }
                    Spacer()
                    Text("\(item.timestamp, format: Date.FormatStyle(time: .shortened))")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
//                                    .padding(.trailing, 10)
                        .padding()
//                                Button {
//                                    withAnimation {
//                                        item.isCompleted.toggle()
//                                    }
//                                } label: {
//                                    Image(systemName: "checkmark")
//                                        .symbolVariant(.circle.fill)
//                                        .foregroundStyle(item.isCompleted ? .green : .gray)
//                                        .font(.largeTitle)
//                                }
//                                .buttonStyle(.plain)
                }
                .frame(width: 340)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)


                .swipeActions(edge: .leading) {
                    Button (role: .destructive){
                        withAnimation {
                            item.isCompleted.toggle()
                        }
                    } label: {
                        Image(uiImage: UIImage(systemName: "arrowshape.turn.up.backward.badge.clock.fill")!.withTintColor(.gray, renderingMode: .alwaysOriginal))
                        }
                        .tint(.clear)
                    }
                    
            }
//            .offset(y:20)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            // padding 用來調整todo之間的間距
            .padding(.vertical, -3)

            
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
    }
    private var sortedItems: [ToDoItem] {
            items.sorted {
                if $0.isCritical != $1.isCritical {
                    return $0.isCritical && !$1.isCritical
                }
                return $0.timestamp < $1.timestamp
            }
        }
}

#Preview {
    ToDo_history()
}
