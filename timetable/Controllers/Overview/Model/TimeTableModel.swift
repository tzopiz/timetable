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

    init(time: String, name: String, location: String, teacher: String, isCancelled: Bool = false) {
        self.time = time
        self.name = name
        self.location = location
        self.teacher = teacher
        self.isCancelled = isCancelled
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
