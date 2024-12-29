//
//  CalendarExporter.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import EventKit
import Foundation

class CalendarExporter {
    private let eventStore = EKEventStore()
    
    func requestAccess() async throws -> Bool {
            if #available(iOS 17.0, *) {
                return try await eventStore.requestFullAccessToEvents()
            } else {
                return try await eventStore.requestAccess(to: .event)
            }
        }
    
    func exportEvent(_ event: Event) async throws {
            let authorized = try await requestAccess()
            guard authorized else {
                throw CalendarError.accessDenied
            }
        
        let calendarEvent = EKEvent(eventStore: eventStore)
        calendarEvent.title = event.title
        calendarEvent.startDate = event.solarDate
        calendarEvent.endDate = Calendar.current.date(byAdding: .hour, value: 1, to: event.solarDate) ?? event.solarDate
        calendarEvent.notes = event.memo
        calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        try eventStore.save(calendarEvent, span: .thisEvent)
    }
    
    enum CalendarError: Error {
        case accessDenied
    }
}
