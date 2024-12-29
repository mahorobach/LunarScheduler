//
//  Event.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/28.
//

import Foundation

struct Event: Identifiable, Codable {
    let id: UUID
    var title: String
    var solarDate: Date
    var memo: String?
    var sharingType: SharingType
    var sharedWith: Set<UUID>  // StringからUUIDに変更
    
    enum SharingType: String, Codable {
        case private_   // 非公開
        case shared     // 特定のユーザー/グループと共有
        case public_    // 全体に公開
    }
    
    init(id: UUID = UUID(), 
         title: String, 
         solarDate: Date, 
         memo: String? = nil,
         sharingType: SharingType = .private_,
         sharedWith: Set<UUID> = []) {  // StringからUUIDに変更
        self.id = id
        self.title = title
        self.solarDate = solarDate
        self.memo = memo
        self.sharingType = sharingType
        self.sharedWith = sharedWith
    }
}
