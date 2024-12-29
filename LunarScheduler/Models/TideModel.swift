//
//  TideModel.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import Foundation

struct TideInfo {
    let time: Date
    let type: TideType
    let height: Double
    
    enum TideType {
        case high, low
        
        var description: String {
            switch self {
            case .high: return "満潮"
            case .low: return "干潮"
            }
        }
        
        var icon: String {
            switch self {
            case .high: return "arrow.up.circle.fill"
            case .low: return "arrow.down.circle.fill"
            }
        }
    }
}

// サンプルデータの生成用の拡張
extension TideInfo {
    static func sampleData() -> [TideInfo] {
        [
            TideInfo(time: Calendar.current.date(bySettingHour: 5, minute: 30, second: 0, of: Date())!,
                     type: .high, height: 1.5),
            TideInfo(time: Calendar.current.date(bySettingHour: 11, minute: 45, second: 0, of: Date())!,
                     type: .low, height: 0.3),
            TideInfo(time: Calendar.current.date(bySettingHour: 17, minute: 20, second: 0, of: Date())!,
                     type: .high, height: 1.8),
            TideInfo(time: Calendar.current.date(bySettingHour: 23, minute: 10, second: 0, of: Date())!,
                     type: .low, height: 0.4)
        ]
    }
}
