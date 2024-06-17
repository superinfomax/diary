//
//  CreateToDoView.swift
//  JourneySpace
//
//  Created by 邱子君 on 2024/6/9.
//

//import SwiftUI
//
//struct CreateToDoView: View {
//    
//    @Environment(\.dismiss) var dismiss
//    
//    @Binding var todos: [ToDoItem]
//    
//    @State private var item = ToDoItem()
//    
//    var body: some View {
//        List {
//            TextField("Title", text: $item.title)
//            DatePicker("Date", selection: $item.date, displayedComponents: .date)
//            Toggle("Important?", isOn: $item.isImportant)
//            Button("Create") {
//                todos.append(item)
//                dismiss()
//            }
//        }
//        .navigationTitle("Create ToDo")
//    }
//}
//
//struct CreateToDoView_Previews: PreviewProvider {
//    @State static var todos = [ToDoItem]()
//    static var previews: some View {
//        CreateToDoView(todos: $todos)
//    }
//}

import SwiftUI

struct CreateToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = ToDoItem()
    
    
    var body: some View {
//        List {
        VStack {
            TextField("What ToDo ?", text: $item.title)
//                .padding(.top, 50)
                .padding(EdgeInsets(top: 30, leading: 30, bottom: 5, trailing: 30))
                .font(.system(size: 30))
            
            Divider()
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30))
            
            
            HStack {
                Spacer()
                Text("TIME")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                Spacer()
            }
            DatePicker("", selection: $item.timestamp)
                .datePickerStyle(.wheel)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30))
                .font(.system(size: 30))

            GeometryReader { geometry in
                            HStack(spacing: 0) {
                                ForEach([300, 600, 900, 1800, 3600, 7200], id: \.self) { interval in
                                    Button(action: {
                                        item.timestamp = Date().addingTimeInterval(TimeInterval(interval))
                                    }) {
                                        Text("\(interval / 60)")
                                            .fontWeight(.bold)
                                            .font(.callout)
                                            .frame(width: geometry.size.width / 6, height: 50)
                                    }
                                    .background(Color(red: 71/255, green: 114/255, blue: 186/255))
                                    .foregroundColor(.white)
                                    .cornerRadius(0) // 圓角設定為0，使其成為一個完整的區塊
                                }
                            }
                            .background(Color.blue)
                            .cornerRadius(15) // 設置整個區塊的圓角
                        }
                        .frame(height: 50)
                        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            
            Toggle("Important !!!", isOn: $item.isCritical)
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 20, trailing: 30))
                .font(.system(size: 30))
            
            Button(action: {
                withAnimation {
                    context.insert(item)
                }
                dismiss()
            },
               label: {
                   Text("Create   ToDo !")
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    .fontWeight(.bold)
                    .font(.title)
            })
            .padding()
            .background(Color(red: 71/255, green: 114/255, blue: 186/255))
            .foregroundColor(.white)
            .cornerRadius(15)
        }
//        .navigationTitle("Create ToDo")
    }
}

#Preview {
    CreateToDoView()
        .modelContainer(for: ToDoItem.self)
}
