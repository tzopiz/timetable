//
//  TimeTableModel.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit

struct Lesson: Codable, Equatable {
    let time: String
    let name: String
    let location: String
    let teacher: String
    let isCancelled: Bool
    let isEmpty: Bool

    init(time: String, name: String, location: String, teacher: String,
         isCancelled: Bool = false, isEmpty: Bool = false) {
        self.time = time
        self.name = name
        self.location = location
        self.teacher = teacher
        self.isCancelled = isCancelled
        self.isEmpty = isEmpty
    }
}
struct StudyDay: Codable, Equatable {
    static func == (lhs: StudyDay, rhs: StudyDay) -> Bool {
        lhs.date == rhs.date && lhs.lessons == rhs.lessons
    }
    
    let date: String
    let lessons: [Lesson]
}
struct StudyWeek: CustomStringConvertible, Codable, Equatable {
    
    static func == (lhs: StudyWeek, rhs: StudyWeek) -> Bool {
        lhs.days == rhs.days && lhs.startDate == rhs.startDate
    }
    
    let startDate: String
    let days: [StudyDay]
    
    var description: String {
        var result = "Start Date: \(startDate)\n"
        for (index, day) in days.enumerated() {
            result += "Day \(index + 1):\n"
            result += "Date: \(day.date)\n"
            for (lessonIndex, lesson) in day.lessons.enumerated() {
                result += "Lesson \(lessonIndex + 1):\n"
                result += "Time: \(lesson.time)\n"
                result += "Name: \(lesson.name)\n"
                result += "Location: \(lesson.location)\n"
                result += "Teacher: \(lesson.teacher)\n"
                result += "Cancelled: \(lesson.isCancelled)\n"
                result += "\n"
            }
            result += "\n"
        }
        return result
    }
}
extension StudyWeek {
    func addingFreeDays(_ date: String) -> StudyWeek {
        func formatDateRus(_ date: Date) -> String {
            let dayFormatter = DateFormatter()
            dayFormatter.locale = Locale(identifier: "ru_RU")
            dayFormatter.dateFormat = "EEEE"
            
            let dayOfWeek = dayFormatter.string(from: date)
            
            let monthFormatter = DateFormatter()
            monthFormatter.locale = Locale(identifier: "ru_RU")
            monthFormatter.dateFormat = "MMMM"
            
            let month = monthFormatter.string(from: date)
            
            let day = Calendar.current.component(.day, from: date)
            
            let resultString = "\(dayOfWeek), \(day) \(month)"
            
            return resultString
        }
        func formatDateEng(_ date: Date) -> String {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMMM"
            
            let dayOfWeek = dayFormatter.string(from: date)
            let month = monthFormatter.string(from: date)
            let day = Calendar.current.component(.day, from: date)
            
            let resultString = "\(dayOfWeek), \(month) \(day)"
            
            return resultString
        }
        if self.days.count == 7 { return StudyWeek(startDate: self.startDate, days: self.days) }
        if self.days.isEmpty { return StudyWeek(startDate: self.startDate, days: []) }
        var updatedDays = self.days
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard var currentDate = dateFormatter.date(from: "\(date)") else { return StudyWeek(startDate: self.startDate, days: []) }
        for i in 0..<7 {
            let (curDayRus, curDayEng) = (formatDateRus(currentDate), formatDateEng(currentDate))
            let isDayPresentRus = updatedDays.contains { $0.date.contains(curDayRus) }
            let isDayPresentEng = updatedDays.contains { $0.date.contains(curDayEng) }
            if !isDayPresentRus && !isDayPresentEng {
                let freeDay = StudyDay(date: curDayRus,
                                       lessons: [Lesson(time: "", name: "",
                                                        location: "", teacher: "",
                                                        isEmpty: true)])
                updatedDays.insert(freeDay, at: i)
            }
            currentDate = currentDate.nextDay
        }
        return StudyWeek(startDate: self.startDate, days: updatedDays)
    }
}
