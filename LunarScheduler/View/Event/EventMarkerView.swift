//
//  EventMarkerView.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import SwiftUI

struct EventMarkerView: View {
    let date: Date
    let events: [Event]
    
    private var eventsForDate: [Event] {
        events.filter { event in
            Calendar.current.isDate(event.solarDate, inSameDayAs: date)
        }
    }
    
    private var markerColor: Color {
        if eventsForDate.contains(where: { $0.sharingType == .public_ }) {
            return .green
        } else if eventsForDate.contains(where: { $0.sharingType == .shared }) {
            return .blue
        }
        return .gray
    }
    
    var body: some View {
        if !eventsForDate.isEmpty {
            Circle()
                .fill(markerColor)
                .frame(width: 6, height: 6)
                .opacity(0.8)
        }
    }
}
