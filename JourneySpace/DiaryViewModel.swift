//
//  DiaryViewModel.swift
//  JourneySpace
//
//  Created by max on 2024/6/7.
//
import Foundation
import SwiftUI
import Combine

class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = []
    
    func addEntry(title: String, content: String, emoji: String) {
        let newEntry = DiaryEntry(title: title, content: content, emoji: emoji, date: Date())
        entries.append(newEntry)
        saveEntries()
    }
    
    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        saveEntries()
    }
    
    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "DiaryEntries") {
            if let decoded = try? JSONDecoder().decode([DiaryEntry].self, from: data) {
                entries = decoded
            }
        }
    }
    
    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "DiaryEntries")
        }
    }
}
