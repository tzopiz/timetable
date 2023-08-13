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
        func formatDate(_ date: Date) -> String {
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

        var updatedDays = self.days
        if self.days.isEmpty { return StudyWeek(startDate: self.startDate, days: []) }
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard var currentDate = dateFormatter.date(from: "\(date)") else { return StudyWeek(startDate: self.startDate, days: []) }
        for i in 0..<7 {
            let isDayPresent = updatedDays.contains { studyDay in
                studyDay.date.contains(formatDate(currentDate))
            }
            if !isDayPresent {
                let freeDay = StudyDay(date: formatDate(currentDate),
                                       lessons: [Lesson(time: " \n", name: " \n",
                                                        location: " \n", teacher: " \n",
                                                        isEmpty: true)])
                updatedDays.insert(freeDay, at: i)
            }
            currentDate = currentDate.nextDay
        }
        return StudyWeek(startDate: self.startDate, days: updatedDays)
    }
}
