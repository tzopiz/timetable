//
//  APIManager.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit
import SwiftSoup

struct Section {
    let title: String
    var items: [String]
    var isExpanded: Bool = false
}

final class APIManager {
    
    static let shared = APIManager()
    private let teachersUrl =
    URL(string: "https://apmath.spbu.ru/studentam/perevody-i-vostanovleniya/13-punkty-menyu/35-prepodavateli.html")
    
    func loadData(with firstDay: String?,
                  completion: @escaping (StudyWeek) -> Void) {
        
        let timeInterval: String
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
                    let startDate = try? startDateElement.attr("data-weekmonday")
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
                } catch { print("Ошибка при разборе HTML: \(error)") }
            }
        }.resume()
    }
    // TODO: -
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
    
    private func loadFaculties(completion: @escaping ([(text: String, href: String)]) -> Void) {
        guard let url = URL(string: UserDefaults.standard.link) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion([])
                return
            } // TODO: there no only faculties at the end
            
            if let data = data, let html = String(data: data, encoding: .utf8) {
                do {
                    // Создаем экземпляр SwiftSoup и загружаем HTML-контент
                    let doc = try SwiftSoup.parse(html)
                    
                    // Выбираем все элементы <li> с классом "list-group-item"
                    let liElements = try doc.select("li.list-group-item")
                    
                    // Обходим каждый элемент <li> и извлекаем значение атрибута href из элемента <a>
                    var elementArray: [(text: String, href: String)] = []
                    
                    for liElement in liElements {
                        if let aElement = try liElement.select("a").first(),
                           let href = try? aElement.attr("href"), !href.isEmpty,
                           let text = try? aElement.text(), !text.isEmpty {
                            elementArray.append((text: text, href: href))
                        }
                    }
                    completion(elementArray)
                } catch {
                    print("Ошибка: \(error)")
                    completion([])
                }
            }
        }
        task.resume()
    }
    func getFaculties() -> [(text: String, href: String)] {
        let semaphore = DispatchSemaphore(value: 0)
        var elements: [(text: String, href: String)] = []
        loadFaculties { result in
            elements = result
            semaphore.signal()
        }
        semaphore.wait()
        return elements
    }
    
    private func loadAndPrintSections(completion: @escaping ([Section]) -> Void) {
        let urlStr = UserDefaults.standard.link
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let data = data, let html = String(data: data, encoding: .utf8) {
                do {
                    let doc = try SwiftSoup.parse(html)
                    let panelElements = try doc.select(".panel-group .panel")
                    var sections: [Section] = []

                    for panelElement in panelElements {
                        let titleElement = try panelElement.select(".panel-heading .panel-title a")
                        let itemsElement = try panelElement.select(".panel-collapse .common-list-item")
                        
                        if let title = try? titleElement.text() {
                            var items: [String] = []
                            
                            for itemElement in itemsElement {
                                if let item = try? itemElement.select("div.col-sm-5").text() {
                                    items.append(item)
                                }
                            }
                            items.removeFirst()
                            let section = Section(title: title, items: items)
                            sections.append(section)
                        }
                    }
                    completion(sections)
                } catch { print("Ошибка при парсинге HTML: \(error)") }
            }
        }
        task.resume()
    }
    func getSections() -> [Section] {
        let semaphore = DispatchSemaphore(value: 0)
        var section: [Section] = []
        loadAndPrintSections { result in
            section = result
            semaphore.signal()
        }
        semaphore.wait()
        return section
    }
    
    private func loadTitle(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: UserDefaults.standard.link) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let html = String(data: data, encoding: .utf8) {
                do {
                    let doc = try SwiftSoup.parse(html)
                    let h2Elements = try doc.select("h2")
                    let title = try h2Elements.first()?.text()
                    completion(title)
                } catch {
                    print("Ошибка при парсинге HTML: \(error)")
                    completion(nil)
                }
            } else { completion(nil) }
        }
        task.resume()
    }
    func getTitle() -> String {
        var result: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        loadTitle { title in
            if let title = title { result = title }
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
}
