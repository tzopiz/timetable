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
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var startOfWeek: Date {
        let components = Date.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        guard let firstDay = Date.calendar.date(from: components) else { return self }
        return Date.calendar.date(byAdding: .day, value: 0, to: firstDay) ?? self
    }
    
    func agoForward(to days: Int) -> Date { Date.calendar.date(byAdding: .day, value: days, to: self) ?? self }
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
    func getMonthChanges(for startDateString: String?) -> String {
        guard let startDateString = startDateString else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = dateFormatter.date(from: startDateString) else {
            return "Неверный формат начальной даты"
        }
        
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: 7, to: startDate) ?? startDate
        let startMonth = calendar.component(.month, from: startDate)
        let endMonth = calendar.component(.month, from: endDate)
        let monthFormatter = DateFormatter()
        
        monthFormatter.dateFormat = "LLLL"
        monthFormatter.locale = Locale(identifier: "ru_RU")
        
        let startMonthString = monthFormatter.string(from: startDate).capitalized
        let endMonthString = monthFormatter.string(from: endDate).capitalized
        
        if startMonth == endMonth { return startMonthString }
        else { return "\(startMonthString)-\(endMonthString)" }
    }
}
