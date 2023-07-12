//
//  APIManager.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit
import SwiftSoup

final class APIManager {
    static let shared = APIManager()
    private let teachersUrl =
    URL(string: "https://apmath.spbu.ru/studentam/perevody-i-vostanovleniya/13-punkty-menyu/35-prepodavateli.html")
    
    func loadData(with firstDay: String?,
                  completion: @escaping (StudyWeek) -> Void) {
        
        let timeInterval: String!
        guard let firstDay = firstDay else { return }
        if firstDay == "\(Date())".components(separatedBy: " ")[0] { timeInterval = "" }
        else { timeInterval = "/" + firstDay }
        
        let url = URL(string: UserDefaults.standard.link + timeInterval)
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Ошибка при чтении данных: \(error)")
                return
            }

            if let data = data, let html = String(data: data, encoding: .utf8) {
                do {
                    let doc = try SwiftSoup.parse(html)

                    let startDateElement = try doc.select("#timetable-week-navigator-chosen-week a")
                    let startDate = try? startDateElement.attr("data-weekmonday") // TODO: что то тут хранить

                    var dayDataArray: [StudyDay] = []

                    for element in try doc.select("div.panel.panel-default") {
                        guard let dateElement = try element.select("div.panel-heading > h4.panel-title").first() else {
                            continue
                        }

                        let date = try dateElement.text().trimmingCharacters(in: .whitespacesAndNewlines)
                        var lessons: [Lesson] = []

                        for lessonElement in try element.select("ul.panel-collapse > li.common-list-item") {
                            let time = try lessonElement.select("div.studyevent-datetime > div.with-icon > div > span.moreinfo").first()?.text() ?? ""
                            let name = try lessonElement.select("div.studyevent-subject > div.with-icon > div > span.moreinfo").first()?.text() ?? ""
                            let location = try lessonElement.select("div.studyevent-locations > div.with-icon > div.address-modal-btn > span.hoverable.link").first()?.text() ?? ""

                            var teacher = ""
                            if let educatorElement = try lessonElement.select("div.studyevent-educators > div.with-icon > div > div > span > span > a").first() {
                                teacher = try educatorElement.text()
                            } else if let educatorElement = try lessonElement.select("div.studyevent-educators > div.with-icon > div > span.hoverable > span > a").first() {
                                teacher = try educatorElement.text()
                            }
                            let isCancelled = try lessonElement.select("div.studyevent-subject > div.with-icon > div > span.moreinfo.cancelled").first() != nil

                            let lesson = Lesson(time: time, name: name, location: location, teacher: teacher, isCancelled: isCancelled)
                            lessons.append(lesson)
                        }

                        let schoolDay = StudyDay(date: date, lessons: lessons)
                        dayDataArray.append(schoolDay)
                    }

                    let schoolWeek = StudyWeek(startDate: Date().getMonthChanges(for: startDate), days: dayDataArray)
                    completion(schoolWeek)
                } catch {
                    print("Ошибка при разборе HTML: \(error)")
                }
            }
        }.resume()
        
    }
    
    func getTeachres(completion: @escaping ([Teacher]) -> Void) {
        guard let url = APIManager.shared.teachersUrl else { return }
        var dataSource: [Teacher] = []
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else { return }
            guard let html = String(data: data, encoding: .utf8) else { return }
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let teachers = try doc.select("td")
                var i = 4
                while i < teachers.count {
                    let name = try teachers[i - 4].text()
                    var info: String = ""
                    if try teachers[i - 3].text().count > 2 {
                        info += try teachers[i - 3].text() + ", "
                    }
                    if try teachers[i - 2].text().count > 2 {
                        info += try teachers[i - 2].text() + ", "
                    }
                    if try teachers[i - 1].text().count > 2 {
                        info += try teachers[i - 1].text()
                    }
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
