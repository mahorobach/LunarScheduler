//
//  EventManager.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/28.
//

import Foundation

class EventManager: ObservableObject {
    @Published var events: [Event] = []
    
    // イベントを追加
    func addEvent(_ event: Event) {
        events.append(event)
        saveEvents()
    }
    
    // イベントを削除
    func deleteEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
        saveEvents()
    }
    
    // イベントを保存
    func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "SavedEvents")
        }
    }
    
    // 保存されたイベントを読み込み
    func loadEvents() {
        if let savedEvents = UserDefaults.standard.data(forKey: "SavedEvents"),
           let decodedEvents = try? JSONDecoder().decode([Event].self, from: savedEvents) {
            events = decodedEvents
        }
    }
    
    func updateEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveEvents()
        }
    }
}
