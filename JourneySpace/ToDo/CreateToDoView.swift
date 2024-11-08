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
import LocalAuthentication
import UserNotifications


struct CreateToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = ToDoItem()
    @State private var selectedDate = Date() // 獨立的日期狀態變數
    
    func scheduleNotification(for item: ToDoItem) {
        let content = UNMutableNotificationContent()
        content.title = "It's time to complete your task!"
        content.body = item.title
        content.sound = .default

        // 設置通知觸發條件
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: item.timestamp)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    var body: some View {
//        List {
        VStack {
            TextField("What ToDo ?", text: $item.title)
//                .padding(.top, 50)
                .padding(EdgeInsets(top: 30, leading: 30, bottom: 5, trailing: 30))
                .font(.system(size: 30))
            
            Divider()
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
            
            
//            HStack {
//                Spacer()
//                Text("TIME")
//                    .font(.system(size: 30))
//                    .foregroundColor(.gray)
//                Spacer()
//            }
            DatePicker("Date & Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30))
                            .font(.system(size: 30))
                            .accentColor(Color(red: 112/255, green: 168/255, blue: 222/255))
//                如果想要有比較小size的datepicker 可以把下面註解取消
//                .frame(width: 320)
//                .presentationCompactAdaptation(.popover)
            

            GeometryReader { geometry in
                            HStack(spacing: 0) {
                                ForEach([300, 600, 900, 1800, 3600, 7200], id: \.self) { interval in
                                    Button(action: {
//                                        item.timestamp = Date().addingTimeInterval(TimeInterval(interval))
                                        let newTime = Calendar.current.date(byAdding: .second, value: interval, to: Date())!
                                                                    selectedDate = Calendar.current.date(
                                                                        bySettingHour: Calendar.current.component(.hour, from: newTime),
                                                                        minute: Calendar.current.component(.minute, from: newTime),
                                                                        second: 0,
                                                                        of: selectedDate
                                                                    ) ?? selectedDate
                                            item.timestamp = selectedDate // 更新 item 的時間戳
                                    }) {
                                        Text("\(interval / 60)")
                                            .fontWeight(.bold)
                                            .font(.callout)
                                            .frame(width: geometry.size.width / 6, height: 50)
                                    }
//                                    .background(Color(red: 71/255, green: 114/255, blue: 186/255))
                                    .background(Color(red: 112/255, green: 168/255, blue: 222/255))
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
                    item.timestamp = selectedDate // 最終確認 item 的時間
                    context.insert(item)
                    scheduleNotification(for: item) // 排程通知
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
            .background(Color(red: 112/255, green: 168/255, blue: 222/255))
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
