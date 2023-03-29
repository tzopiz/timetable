//
//  TimeTableModel.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit
struct StudyDay: Codable {
    struct Lesson: Codable {
        let time: String
        let nameSubject: String
        let address: String
        let teacherName: String
        
    }
    let date: String
    var lessons: [Lesson]
}
