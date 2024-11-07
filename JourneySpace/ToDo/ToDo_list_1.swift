//
//  ToDo_list_1.swift
//  JourneySpace
//
//  Created by max on 2024/6/8.
//  Edited by Jessie on 2024/6/8
//  藍色色碼    .background(Color(red: 71/255, green: 114/255, blue: 186/255))

import SwiftUI
import SwiftData
import Foundation

struct TodoPage1: View {
    
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var toDoToEdit: ToDoItem?
    @Query(
        filter: #Predicate<ToDoItem> { $0.isCompleted == false },
        sort: \.timestamp,
        order: .forward
    ) private var items: [ToDoItem]
    
    init() {
        // 使用這個設置大標題字體
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont(name: "Georgia-Bold", size: 20)!]
        
        // 使用這個設置小標題字體
        // UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: "Georgia-Bold", size: 20)!]
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Image("yeloplanet")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
//                Color(red: 71/255, green: 114/255, blue: 186/255)
//                    .edgesIgnoringSafeArea(.all)
                VStack (){
                    Spacer()
                    // Image 4 is Yellow monster
                    Image("Image 4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
//                        .padding(.top, 1)
//                        .offset(y:-15)
                    
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

                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        context.delete(item)
                                    }
                                } label: {
//                                  Image(systemName: "trash")
//                                      .foregroundColor(.white)
//                                      .font(.system(size: 20))
//                                    Image(uiImage: UIImage(systemName:    "trash")!.withTintColor(.red,                                                       renderingMode: .alwaysOriginal))
                                    Image("trashCan_icon_ToDo")
                                }
                                .tint(.clear)
                                
                                Button {
                                    toDoToEdit = item
                                } label: {
//                                    Image(uiImage: UIImage(systemName: "square.and.pencil")!.withTintColor(.white,                                            renderingMode: .alwaysOriginal))
                                    Image("edit_icon_ToDo")
                                }
                                .tint(.clear)
                                .border(Color.red, width: 5)
                            }
                            .swipeActions(edge: .leading) {
                                Button (role: .destructive){
                                    withAnimation {
                                        item.isCompleted.toggle()
                                    }
                                } label: {
                                    Image(uiImage: UIImage(systemName: "checkmark.circle.fill")!.withTintColor(.green, renderingMode: .alwaysOriginal))
                                    }
                                    .tint(.clear)
                                }
                                
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        // padding 用來調整todo之間的間距
                        .padding(.vertical, -3)

                        
                    }
                    .offset(y:-20)
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        //下面的ToDo是暫時用來修NavigationLink from ToDo_history 的 bug（object not at the right postition）
                        Text("ToDo")
                            .font(.system(size: 60))
                            .bold()
                            .foregroundColor(Color.clear)
                            .offset(y:10)
                        
                        Button(action: {
                            showCreate.toggle()
                        }, label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.white)
                                .bold()
                                .offset(y:10)
                        })
                        Spacer()
                        NavigationLink {
                            ToDo_history()
                        } label: {
                            Image(systemName: "text.book.closed.fill")
                                .foregroundColor(.white)
                                .bold()
                                .offset(y:10)
                                .padding(.leading,110)
                        }
                    }
                }
            }
            Text("ToDo")
                .font(.system(size: 60))
                .bold()
                .foregroundColor(Color.white)
                .offset(y:10)
                .position(x:85, y: -775)
            
            .sheet(isPresented: $showCreate, content: {
                NavigationStack {
                    CreateToDoView()
                }
//                .presentationDetents([.medium ,.large])
//                .presentationDetents([.fraction(0.8)])
                .presentationDetents([.large])
            })
            .sheet(item: $toDoToEdit) {
                toDoToEdit = nil
            } content: { item in
                UpdateToDoView(item: item)
            }
        }
        .onChange(of: items) { _ in
            // 當 items 發生變化時，自動更新 View
        }
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




struct ToDo_List_1_Previews: PreviewProvider {
    static var previews: some View {
        TodoPage1()
    }
}
