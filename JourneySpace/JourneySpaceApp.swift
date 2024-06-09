//
//  JourneySpaceApp.swift
//  JourneySpace
//
//  Created by max on 2024/5/26.
//

import SwiftUI
import Foundation
import SwiftData
@main
struct JourneySpaceApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
        }.modelContainer(for: ToDoItem.self)
    }
}
