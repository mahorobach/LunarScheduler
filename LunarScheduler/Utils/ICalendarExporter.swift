//
//  ICalendarExporter.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import Foundation

class ICalendarExporter {
    func generateICalendarString(for event: Event) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        let dateString = formatter.string(from: event.solarDate)
        let endDateString = formatter.string(from: Calendar.current.date(byAdding: .hour, value: 1, to: event.solarDate) ?? event.solarDate)
        
        let icsString = """
        BEGIN:VCALENDAR
        VERSION:2.0
        PRODID:-//LunarScheduler//EN
        BEGIN:VEVENT
        UID:\(event.id.uuidString)
        DTSTAMP:\(dateString)
        DTSTART:\(dateString)
        DTEND:\(endDateString)
        SUMMARY:\(event.title)
        DESCRIPTION:\(event.memo ?? "")
        END:VEVENT
        END:VCALENDAR
        """
        
        return icsString
    }
    
    func exportToFile(event: Event) -> URL? {
        let icsString = generateICalendarString(for: event)
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsDirectory = paths.first else { return nil }
        
        let fileURL = documentsDirectory.appendingPathComponent("\(event.title).ics")
        
        do {
            try icsString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error saving file: \(error)")
            return nil
        }
    }
}
