//
//  WeatherModel.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import SwiftUI

// 天気の状態を表すenum
enum WeatherCondition {
    case sunny, cloudy, rainy, cloudyWithSunny, snowy
    
    var icon: Image {
        switch self {
        case .sunny: return Image(systemName: "sun.max.fill")
        case .cloudy: return Image(systemName: "cloud.fill")
        case .rainy: return Image(systemName: "cloud.rain.fill")
        case .cloudyWithSunny: return Image(systemName: "cloud.sun.fill")
        case .snowy: return Image(systemName: "snow")
        }
    }
    
    // 天気状態の日本語表記を追加
    var description: String {
        switch self {
        case .sunny: return "晴れ"
        case .cloudy: return "曇り"
        case .rainy: return "雨"
        case .cloudyWithSunny: return "晴れ時々曇り"
        case .snowy: return "雪"
        }
    }
}


