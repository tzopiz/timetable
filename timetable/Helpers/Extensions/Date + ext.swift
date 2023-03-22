//
//  Date + ext.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import Foundation

extension Date {
    enum StripTimeType: CaseIterable {
        case toDays
        case toMinutes
    }
    static var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar
    }()

    var startOfWeek: Date {
        let components = Date.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        guard let firstDay = Date.calendar.date(from: components) else { return self }
        return Date.calendar.date(byAdding: .day, value: 0, to: firstDay) ?? self
    }
    func agoForward(to days: Int) -> Date {
        return Date.calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func stripTime(_ stripTimeType: Date.StripTimeType) -> Date {
        switch stripTimeType {
        case .toDays:
            let components = Date.calendar.dateComponents([.year, .month, .day], from: self)
            return Date.calendar.date(from: components) ?? self
        case .toMinutes:
            let components = Date.calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
            return Date.calendar.date(from: components) ?? self
        }
    }
}
