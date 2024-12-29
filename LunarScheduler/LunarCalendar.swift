import Foundation

struct LunarCalendar {
    struct LunarInfo {
        let year: Int
        let month: Int
        let day: Int
        let isLeapMonth: Bool
        
        var yearDisplay: String {
            let stems = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
            let branches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
            let stemIndex = (year - 4) % 10
            let branchIndex = (year - 4) % 12
            return "\(stems[stemIndex])\(branches[branchIndex])年 (\(year))"
        }
        
        var dateDisplay: String {
            let monthStr = isLeapMonth ? "閏\(month)" : "\(month)"
            return "旧暦 \(monthStr)月\(day)日"
        }
    }

    private static let lunarMonthStarts2024: [(month: Int, startDate: Date)] = [
        (1, createDate(2024, 2, 10)),  // 旧正月
        (2, createDate(2024, 3, 11)),
        (3, createDate(2024, 4, 9)),
        (4, createDate(2024, 5, 8)),
        (5, createDate(2024, 6, 7)),
        (6, createDate(2024, 7, 6)),
        (7, createDate(2024, 8, 5)),
        (8, createDate(2024, 9, 4)),
        (9, createDate(2024, 10, 3)),
        (10, createDate(2024, 11, 2)),
        (11, createDate(2024, 12, 1)),
        (12, createDate(2024, 12, 31))
    ]
    
    static func getLunarInfo(for solarDate: Date) -> LunarInfo {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: solarDate)
        
        // 2024年のデータを使用
        let monthStarts = lunarMonthStarts2024
        
        // 該当する旧暦月を見つける
        for i in 0..<monthStarts.count {
            let currentStart = monthStarts[i]
            let nextStart = i < monthStarts.count - 1
                ? monthStarts[i + 1].startDate
                : createDate(2025, 1, 30)
            
            if solarDate >= currentStart.startDate && solarDate < nextStart {
                // 日数を計算
                let days = calendar.dateComponents([.day], from: currentStart.startDate, to: solarDate).day ?? 0
                let lunarDay = days + 1
                
                // 年の調整（正月前は前年）
                let lunarYear = currentStart.month == 1 &&
                    calendar.component(.month, from: solarDate) < 2 ? year - 1 : year
                
                return LunarInfo(
                    year: lunarYear,
                    month: currentStart.month,
                    day: lunarDay,
                    isLeapMonth: false
                )
            }
        }
        
        // フォールバック（該当する期間が見つからない場合）
        return LunarInfo(
            year: year,
            month: 1,
            day: 1,
            isLeapMonth: false
        )
    }
    
    private static func createDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }
}
