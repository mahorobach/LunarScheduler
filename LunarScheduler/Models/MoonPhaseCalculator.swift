//
//  MoonPhaseCalculator.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//
import SwiftUI


// 月の満ち欠けを表すenum
enum MoonPhase: Int {  // Int型のraw valueを追加
    case day0 = 0, day1, day2, day3, day4, day5, day6, day7
    case day8, day9, day10, day11, day12, day13, day14
    case day15, day16, day17, day18, day19, day20, day21
    case day22, day23, day24, day25, day26, day27, day28, day29
    
    static func fromDate(_ date: Date) -> MoonPhase {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return MoonPhase(rawValue: day % 30) ?? .day0
    }
    
    var icon: Image {
        switch self {
        case .day0: return Image(systemName: "moon.new")  // 新月
        case .day7: return Image(systemName: "moon.first.quarter")  // 上弦
        case .day15: return Image(systemName: "moon.full")  // 満月
        case .day22: return Image(systemName: "moon.last.quarter")  // 下弦
        default:
            // 中間の月相は適切なアイコンを選択
            if self.rawValue < 7 {
                return Image(systemName: "moon.waxing.crescent")
            } else if self.rawValue < 15 {
                return Image(systemName: "moon.waxing.gibbous")
            } else if self.rawValue < 22 {
                return Image(systemName: "moon.waning.gibbous")
            } else {
                return Image(systemName: "moon.waning.crescent")
            }
        }
    }
}

// 月の満ち欠け計算用の構造体
struct MoonPhaseCalculator {
    static func calculatePhase(for date: Date) -> Double {
        // 2000年1月6日 18:14 UTCを新月の基準日とする
        let baseDate = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 6, hour: 18, minute: 14))!
        
        // 月の周期（29.53059日）
        let lunarMonth = 29.53059
        
        let timeInterval = date.timeIntervalSince(baseDate)
        let days = timeInterval / (24 * 3600) // 経過日数
        
        // 月齢を0-1の値で返す（0: 新月, 0.5: 満月）
        let phase = ((days / lunarMonth) - floor(days / lunarMonth))
        return phase
    }
}
