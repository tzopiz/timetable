//
//  Date + ext.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import Foundation

enum time: CaseIterable {
    case Day
    case Minute
}

extension Date {
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

    func stripTime(_ _case: time) -> Date {
        switch _case {
        case .Day:
            let components = Date.calendar.dateComponents([.year, .month, .day], from: self)
            return Date.calendar.date(from: components) ?? self
        case .Minute:
            let components = Date.calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
            return Date.calendar.date(from: components) ?? self
        }
    }
}
