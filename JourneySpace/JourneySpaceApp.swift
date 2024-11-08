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

@main
struct JourneySpaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var prizeManager = PrizeManager() // 新增 PrizeManager 狀態
    var body: some Scene {
        WindowGroup {
            LoginView()
                .modelContainer(for: ToDoItem.self)
                .environmentObject(prizeManager) // 將 prizeManager 傳入環境
        }
    }
}

class PrizeManager: ObservableObject {
    @Published var collectedPrizes: [Prize] = []
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerForNotification()
        return true
    }
    
    
    func registerForNotification() {
        //For device token and push notifications.
        UIApplication.shared.registerForRemoteNotifications()
        
        let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
        //        center.delegate = self
        
        center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
            if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
            else {
                
            }
        })
    }
}
