//
//  GroupManager.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import Foundation

class GroupManager: ObservableObject {
    @Published var groups: [Group] = []
    
    // グループの作成
    func createGroup(name: String, members: [UUID]) -> Group {
        let group = Group(name: name, members: members)
        groups.append(group)
        saveGroups()
        return group
    }
    
    // グループへのイベント追加
    func addEventToGroup(groupId: UUID, eventId: UUID) {
        if let index = groups.firstIndex(where: { $0.id == groupId }) {
            groups[index].events.append(eventId)
            saveGroups()
        }
    }
    
    // グループ内の全イベントを取得
    func getEventsForGroup(groupId: UUID) -> [UUID] {
        if let group = groups.first(where: { $0.id == groupId }) {
            return group.events
        }
        return []
    }
    
    private func saveGroups() {
        if let encoded = try? JSONEncoder().encode(groups) {
            UserDefaults.standard.set(encoded, forKey: "SavedGroups")
        }
    }
    
    func loadGroups() {
        if let savedGroups = UserDefaults.standard.data(forKey: "SavedGroups"),
           let decodedGroups = try? JSONDecoder().decode([Group].self, from: savedGroups) {
            groups = decodedGroups
        }
    }
}
