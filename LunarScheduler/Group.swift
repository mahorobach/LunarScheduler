//
//  Group.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import Foundation

struct Group: Identifiable, Codable {
    let id: UUID
    var name: String
    var members: [UUID]  // StringからUUIDに変更
    var events: [UUID]
    
    init(id: UUID = UUID(), name: String, members: [UUID] = [], events: [UUID] = []) {
        self.id = id
        self.name = name
        self.members = members
        self.events = events
    }
}
