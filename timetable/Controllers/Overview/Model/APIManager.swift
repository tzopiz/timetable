//
//  APIManager.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit
import SwiftSoup

class APIManager {
    static let shared = APIManager()
    static let urls = [
    URL(string: "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334102"),
    URL(string: "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334471"),
    URL(string: "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334404"),
    URL(string: "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334120"),
    URL(string: "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334111"),
    URL(string: "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334488"),
    URL(string: "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/333990"),
    URL(string: "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334477"),
    URL(string: "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334029")
    ]
    func getTimetable(completion: @escaping ([StudyDay]) -> Void) {
        guard let url = APIManager.urls[3] else { return }
        var dataSource: [StudyDay] = []
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            guard let html = String(data: data, encoding: .utf8) else { return }
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let timeAndName = try doc.getElementsByClass("moreinfo")
//                let weekId = try doc.getElementById("week")
                let teachersAndAdress = try doc.getElementsByClass("hoverable")
                let days = try doc.getElementsByClass("panel-title")
                let divSelect = try doc.select("div")
                var numberOfLesson: [Int] = []
                var counter = 0

                // define number of lessons
                for i in 24..<divSelect.count {
                    if i == divSelect.count - 1 {
                        counter += 2
                        counter = (counter - 1) / 12
                        numberOfLesson.append((counter - 1) / 12)
                        numberOfLesson.removeFirst()
                        continue
                    }
                    if numberOfLesson.count < days.count {
                        if (try divSelect[i].text()) == (try days[numberOfLesson.count].text()) {
                            numberOfLesson.append((counter - 1) / 12)
                            counter = -1
                        }
                    }
                    counter += 1
                }
                var i = 1
                var currentDay = 0
                var needNumberOfLessonToday = numberOfLesson[0]
                var lessonsToday: [StudyDay.Lesson] = []
                while i < teachersAndAdress.count && i < timeAndName.count {
                    if lessonsToday.count == needNumberOfLessonToday {
                        dataSource.append(StudyDay(date: try days[currentDay].text(), lessons: lessonsToday))
                        currentDay += 1
                        needNumberOfLessonToday = numberOfLesson[currentDay]
                        lessonsToday.removeAll()
                    }
                    let lesson: StudyDay.Lesson
                    = StudyDay.Lesson(time: try timeAndName[i - 1].text(),
                                      nameSubject: try timeAndName[i].text(),
                                      address: try teachersAndAdress[i - 1].text(),
                                      teacherName: try teachersAndAdress[i].text())
                    lessonsToday.append(lesson)
                    i += 2
                }
                dataSource.append(StudyDay(date: try days[currentDay].text(), lessons: lessonsToday))
                print(dataSource)
                completion(dataSource)
            } catch { print(error.localizedDescription) }
        }
        task.resume()
    }
}
