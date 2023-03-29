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
    static let urlsStrings = [
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334102",
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334471",
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334404",
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334120",
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334111",
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334488",
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/333990",
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334477",
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334029",
    "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334120/2023-04-03"
    ]
    static let teachersUrl = URL(string: "https://apmath.spbu.ru/studentam/perevody-i-vostanovleniya/13-punkty-menyu/35-prepodavateli.html")
    func getTimetable(with firstDay: String, completion: @escaping ([StudyDay], String) -> Void) {
        let timeInterval: String!
        if firstDay == "\(Date())".components(separatedBy: " ")[0] {
            timeInterval = ""
        } else {
            timeInterval = "/" + firstDay
        }
        let numberOfGroup = Int(UserDefaults.standard.group.components(separatedBy: ",").last ?? "-1") ?? 0
        let url = URL(string: APIManager.urlsStrings[numberOfGroup] + timeInterval)
        guard let url = url else { return }
        var dataSource: [StudyDay] = []
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            guard let html = String(data: data, encoding: .utf8) else { return }
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let timeAndName = try doc.getElementsByClass("moreinfo")
                let teachersAndAdress = try doc.getElementsByClass("hoverable")
                let days = try doc.getElementsByClass("panel-title")
                let divSelect = try doc.select("div")
                var numberOfLesson: [Int] = []
                var counter = 0
                let weekId = try doc.getElementById("week")
                guard let weekId = weekId else { return }
                let weekText = try weekId.text()

                // define number of lessons
                if days.isEmpty() {
                    completion([], "")
                    return
                }
                for j  in 0..<divSelect.count {
                    if j == divSelect.count - 1 {
                        counter += 2
                        numberOfLesson.append((counter - 1) / 12)
                        numberOfLesson.removeFirst()
                        break
                    }
                    if numberOfLesson.count < days.count {
                        if (try divSelect[j].text()) == (try days[numberOfLesson.count].text()) {
                            numberOfLesson.append((counter - 1) / 12)
                            counter = -1
                        }
                    }
                    counter += 1
                }
                var i = 1
                var currentDay = 0
                var needNumberOfLessonToday = numberOfLesson.first
                var lessonsToday: [StudyDay.Lesson] = []
                while i < teachersAndAdress.count && i < timeAndName.count && currentDay < numberOfLesson.count {
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
                    i += 2 // 2 var read 2 line every time
                    if i >= teachersAndAdress.count || i >= timeAndName.count {
                        dataSource.append(StudyDay(date: try days[currentDay].text(), lessons: lessonsToday))
                    }
                }
                completion(dataSource, weekText)
            } catch { print(error.localizedDescription) }
        }
        task.resume()
    }
    func getTeachres(completion: @escaping ([Teacher]) -> Void) {
        guard let url = APIManager.teachersUrl else { return }
        var dataSource: [Teacher] = []
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            guard let html = String(data: data, encoding: .utf8) else { return }
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let teachers = try doc.select("td")
                var i = 4
                while i < teachers.count {
                    let name = try teachers[i - 4].text()
                    var info = try teachers[i - 3].text() + ", "
                    info += try teachers[i - 2].text() + ", "
                    info += try teachers[i - 1].text()
                    let teacher = Teacher(name: name, info: info)
                    dataSource.append(teacher)
                    i += 4
                }
                completion(dataSource)
            } catch { print(error.localizedDescription) }
        }
        task.resume()
        
    }
}
