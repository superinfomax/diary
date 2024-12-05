//
//  GoogleCalendarManager.swift
//  TextFontDemo
//
//  Created by max on 2024/11/24.
//

import GoogleSignIn
import GoogleAPIClientForREST_Calendar
import Foundation

class GoogleCalendarManager {
    private var service: GTLRCalendarService
    static let shared = GoogleCalendarManager()
    
    enum CalendarError: Error {
        case eventNotFound
        case userNotSignedIn
        case networkError
    }
    
    init() {
        service = GTLRCalendarService()
        setupService()
    }
    
    private func setupService() {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            print("🔴 No user signed in")
            return
        }
        service.authorizer = user.fetcherAuthorizer
    }
    

    func fetchEvents(from startDate: Date, to endDate: Date) async throws -> [CalendarEvent] {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            throw CalendarError.userNotSignedIn
        }
        
        // Refresh tokens
        try await user.refreshTokensIfNeeded()
        service.authorizer = user.fetcherAuthorizer

        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")
        query.timeMin = GTLRDateTime(date: startDate)
        query.timeMax = GTLRDateTime(date: endDate)
        query.orderBy = "startTime"
        query.singleEvents = true

        // Execute query
        // Execute query
        let ticket: Any = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            service.executeQuery(query) { ticket, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: result ?? ticket)
            }
        }

        guard let eventsList = ticket as? GTLRCalendar_Events,
              let items = eventsList.items else {
            throw CalendarError.networkError
        }

        return items.compactMap { event -> CalendarEvent? in
            guard let id = event.identifier,
                  let startDateTime = event.start?.dateTime?.date ?? event.start?.date?.date,
                  let endDateTime = event.end?.dateTime?.date ?? event.end?.date?.date else {
                return nil
            }
            
            return CalendarEvent(
                id: id,
                title: event.summary ?? "無標題",
                startDate: startDateTime,
                endDate: endDateTime,
                colorHex: event.colorId,
                description: event.descriptionProperty
            )
        }
    }
    func createEvent(title: String, startDate: Date, endDate: Date, completion: @escaping (Result<GTLRCalendar_Event, Error>) -> Void) {
        print("🟡 Starting create event process...")
        
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not signed in"])))
            return
        }
        
        user.refreshTokensIfNeeded { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    print("🔴 Token refresh failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                return
            }
            
            guard let user = user else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to refresh token"])))
                }
                return
            }
            
            self.service.authorizer = user.fetcherAuthorizer
            
            let event = GTLRCalendar_Event()
            event.summary = title
            
            let startDateTime = GTLRCalendar_EventDateTime()
            startDateTime.dateTime = GTLRDateTime(date: startDate)
            startDateTime.timeZone = TimeZone.current.identifier
            event.start = startDateTime
            
            let endDateTime = GTLRCalendar_EventDateTime()
            endDateTime.dateTime = GTLRDateTime(date: endDate)
            endDateTime.timeZone = TimeZone.current.identifier
            event.end = endDateTime
            
            print("📝 Creating event: \(title)")
            print("📝 Start time: \(startDate)")
            print("📝 End time: \(endDate)")
            
            let query = GTLRCalendarQuery_EventsInsert.query(withObject: event, calendarId: "primary")
            
            self.service.executeQuery(query) { (ticket, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("🔴 Create event failed: \(error.localizedDescription)")
                        completion(.failure(error))
                        return
                    }
                    
                    guard let createdEvent = response as? GTLRCalendar_Event else {
                        completion(.failure(NSError(domain: "GoogleCalendarError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create event"])))
                        return
                    }
                    
                    print("✅ Event created successfully")
                    completion(.success(createdEvent))
                }
            }
        }
    }
    
    func deleteEvent(with eventId: String, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let user = GIDSignIn.sharedInstance.currentUser else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not signed in"])))
                return
            }
            
            user.refreshTokensIfNeeded { [weak self] user, error in
                guard let self = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        print("🔴 Token refresh failed: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let user = user else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to refresh token"])))
                    }
                    return
                }
                
                self.service.authorizer = user.fetcherAuthorizer
                
                let query = GTLRCalendarQuery_EventsDelete.query(withCalendarId: "primary", eventId: eventId)
                
                self.service.executeQuery(query) { (ticket, response, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("🔴 Delete event failed: \(error.localizedDescription)")
                            completion(.failure(error))
                            return
                        }
                        
                        print("✅ Event deleted successfully")
                        completion(.success(()))
                    }
                }
            }
        }
    
    func updateEventDescription(eventId: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            completion(.failure(CalendarError.userNotSignedIn))
            return
        }
        
        user.refreshTokensIfNeeded { [weak self] user, error in
            guard let self = self else { return }
            
            // 先獲取現有事件
            let query = GTLRCalendarQuery_EventsGet.query(withCalendarId: "primary", eventId: eventId)
            
            self.service.executeQuery(query) { (ticket, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let event = response as? GTLRCalendar_Event else {
                    completion(.failure(CalendarError.eventNotFound))
                    return
                }
                
                // 更新 description
                event.descriptionProperty = description
                
                // 儲存更新
                let updateQuery = GTLRCalendarQuery_EventsUpdate.query(withObject: event,
                                                                     calendarId: "primary",
                                                                     eventId: eventId)
                
                self.service.executeQuery(updateQuery) { (ticket, response, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    // 為 ToDo 創建日曆事件
    func createEventForToDo(_ todoItem: ToDoItem, completion: @escaping (Result<String, Error>) -> Void) {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            completion(.failure(NSError(domain: "GoogleCalendarError",
                                     code: -1,
                                     userInfo: [NSLocalizedDescriptionKey: "User not signed in"])))
            return
        }
        
        user.refreshTokensIfNeeded { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            self.service.authorizer = user?.fetcherAuthorizer
            
            let event = GTLRCalendar_Event()
            event.summary = todoItem.title
            
            // 設置開始時間
            let startDateTime = GTLRCalendar_EventDateTime()
            startDateTime.dateTime = GTLRDateTime(date: todoItem.timestamp)
            startDateTime.timeZone = TimeZone.current.identifier
            event.start = startDateTime
            
            // 設置結束時間 (使用相同時間)
            let endDateTime = GTLRCalendar_EventDateTime()
            endDateTime.dateTime = GTLRDateTime(date: todoItem.timestamp)
            endDateTime.timeZone = TimeZone.current.identifier
            event.end = endDateTime
            
            // 添加提醒設置
            let reminder = GTLRCalendar_EventReminder()
            reminder.method = "popup"
            reminder.minutes = 10  // 10分鐘前提醒
            
            let reminders = GTLRCalendar_Event_Reminders()
            reminders.overrides = [reminder]
            reminders.useDefault = false
            event.reminders = reminders
            
            let query = GTLRCalendarQuery_EventsInsert.query(withObject: event, calendarId: "primary")
            
            self.service.executeQuery(query) { (ticket, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let createdEvent = response as? GTLRCalendar_Event,
                          let eventId = createdEvent.identifier else {
                        completion(.failure(NSError(domain: "GoogleCalendarError",
                                                 code: -1,
                                                 userInfo: [NSLocalizedDescriptionKey: "Failed to create event"])))
                        return
                    }
                    
                    completion(.success(eventId))
                }
            }
        }
    }
    
    // 更新 ToDo 對應的日曆事件
    func updateEventForToDo(_ todoItem: ToDoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let eventId = todoItem.getGoogleEventId() else {
            completion(.failure(NSError(domain: "GoogleCalendarError",
                                     code: -1,
                                     userInfo: [NSLocalizedDescriptionKey: "No Google Calendar event ID found"])))
            return
        }
        
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            completion(.failure(NSError(domain: "GoogleCalendarError",
                                     code: -1,
                                     userInfo: [NSLocalizedDescriptionKey: "User not signed in"])))
            return
        }
        
        user.refreshTokensIfNeeded { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            self.service.authorizer = user?.fetcherAuthorizer
            
            let event = GTLRCalendar_Event()
            event.summary = todoItem.title
            
            let startDateTime = GTLRCalendar_EventDateTime()
            startDateTime.dateTime = GTLRDateTime(date: todoItem.timestamp)
            startDateTime.timeZone = TimeZone.current.identifier
            event.start = startDateTime
            
            let endDateTime = GTLRCalendar_EventDateTime()
            endDateTime.dateTime = GTLRDateTime(date: todoItem.timestamp)
            endDateTime.timeZone = TimeZone.current.identifier
            event.end = endDateTime
            
            let query = GTLRCalendarQuery_EventsUpdate.query(withObject: event,
                                                           calendarId: "primary",
                                                           eventId: eventId)
            
            self.service.executeQuery(query) { (ticket, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(()))
                }
            }
        }
    }
    
    // 刪除 ToDo 對應的日曆事件
    func deleteEventForToDo(_ todoItem: ToDoItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let eventId = todoItem.getGoogleEventId() else {
            completion(.success(())) // 如果沒有對應的日曆事件，就直接返回成功
            return
        }
        
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            completion(.failure(NSError(domain: "GoogleCalendarError",
                                     code: -1,
                                     userInfo: [NSLocalizedDescriptionKey: "User not signed in"])))
            return
        }
        
        user.refreshTokensIfNeeded { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            self.service.authorizer = user?.fetcherAuthorizer
            
            let query = GTLRCalendarQuery_EventsDelete.query(withCalendarId: "primary",
                                                           eventId: eventId)
            
            self.service.executeQuery(query) { (ticket, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(()))
                }
            }
        }
    }
    
    func syncToDoItemWithCalendar(_ item: ToDoItem, completion: @escaping (Bool) -> Void) {
        guard let eventId = item.getGoogleEventId() else {
            completion(true)
            return
        }
        
        let query = GTLRCalendarQuery_EventsGet.query(withCalendarId: "primary", eventId: eventId)
        
        service.executeQuery(query) { (ticket, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to fetch event: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let event = response as? GTLRCalendar_Event,
                      let startDate = event.start?.dateTime?.date else {
                    completion(false)
                    return
                }
                
                // 更新本地待辦事項
                if let title = event.summary {
                    item.title = title
                }
                item.timestamp = startDate
                
                completion(true)
            }
        }
    }

}
