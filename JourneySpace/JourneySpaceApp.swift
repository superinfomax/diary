//
//  JourneySpaceApp.swift
//  JourneySpace
//
//  Created by max on 2024/5/26.
//

import SwiftUI
import Foundation
import SwiftData
import UIKit
import EventKit  // 添加 EventKit

@main
struct JourneySpaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var prizeManager = PrizeManager()
    
    init() {
        // 設置 Google Sign-In
        GoogleAuthService.shared.setupGoogleSignIn()
    }
    var body: some Scene {
        WindowGroup {
            LoginView()
                .modelContainer(for: ToDoItem.self)
                .environmentObject(prizeManager)
                .onAppear {
                    Task {
                        do {
                            let granted = try await RemindersManager.shared.requestAccess()
                            if granted {
                                print("Reminders access granted")
                            } else {
                                print("Reminders access denied")
                            }
                        } catch {
                            print("Error requesting Reminders access: \(error)")
                        }
                    }
                }
        }
    }
}

class PrizeManager: ObservableObject {
    @Published var collectedPrizes: [Prize] = []
}

class AppDelegate: NSObject, UIApplicationDelegate {
    let eventStore = EKEventStore()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerForNotification()
        requestRemindersAccess()
        return true
    }
    
    func requestRemindersAccess() {
        Task {
            do {
                if #available(iOS 17.0, *) {
                    let granted = try await eventStore.requestFullAccessToReminders()
                    print("Reminders access \(granted ? "granted" : "denied")")
                } else {
                    let granted = await withCheckedContinuation { continuation in
                        eventStore.requestAccess(to: .reminder) { granted, error in
                            continuation.resume(returning: granted)
                        }
                    }
                    print("Reminders access \(granted ? "granted" : "denied")")
                }
            } catch {
                print("Error requesting Reminders access: \(error)")
            }
        }
    }
    
    func registerForNotification() {
        UIApplication.shared.registerForRemoteNotifications()
        
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
            if ((error != nil)) {
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
    }
}
