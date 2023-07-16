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
struct SectionWithLinks {
    let title: String
    let items: [(String, String)]
    var isExpanded: Bool = false
}

final class APIManager {
    
    static let shared = APIManager()
    private let teachersUrl =
    URL(string: "https://apmath.spbu.ru/studentam/perevody-i-vostanovleniya/13-punkty-menyu/35-prepodavateli.html")
    
    // TODO: --
    
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

// MARK: - list of faculties

extension APIManager {
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
    /// name of Faculties
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
}

// MARK: - Timetable
extension APIManager {
    /// timetable
    func loadTimetableData(with firstDay: String?, completion: @escaping (StudyWeek) -> Void) {
        
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
}

// MARK: - list of directions + title for headerView of list directions

extension APIManager {
    private func loadDirectionsTitles(completion: @escaping ([String]) -> Void) {
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
                    var titles: [String] = []
                    
                    for panelElement in panelElements {
                        let titleElement = try panelElement.select(".panel-heading .panel-title a")
                        
                        if let title = try? titleElement.text() {
                            titles.append(title)
                        }
                    }
                    completion(titles)
                } catch { print("Ошибка при парсинге HTML: \(error)") }
            }
        }
        task.resume()
    }
    ///  directions(bak, mag, ..)
    func getDirections() -> [String] {
        let semaphore = DispatchSemaphore(value: 0)
        var ans: [String] = []
        loadDirectionsTitles { result in
            ans = result
            semaphore.signal()
        }
        semaphore.wait()
        return ans
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
    /// title of list directions
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

// MARK: - only years of groups

extension APIManager {
    private func loadGroupsTitles(completion: @escaping ([Section]) -> Void) {
        guard let url = URL(string:  UserDefaults.standard.link) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Ошибка при загрузке данных: \(error?.localizedDescription ?? "")")
                completion([])
                return
            }
            
            do {
                let html = String(data: data, encoding: .utf8)
                let doc: Document = try SwiftSoup.parse(html ?? "")
                let listItems = try doc.select("li.common-list-item.row")
                var sections: [Section] = []
                
                for listItem in listItems {
                    var sectionItems: [String] = []
                    
                    // Извлечение значения заголовка
                    if let titleElement = try listItem.select("div.col-sm-5").first() {
                        let title = try titleElement.text()
                        if title == "Образовательная программа" { continue }
                        // Извлечение значений элементов списка
                        let listElements = try listItem.select("a")
                        for listElement in listElements {
                            let item = try listElement.text()
                            sectionItems.append(item)
                        }
                        sections.append(Section(title: title, items: sectionItems))
                    }
                }
                completion(sections)
            } catch {
                print("Ошибка при парсинге HTML: \(error)")
                completion([])
            }
        }
        task.resume()
    }
    /// list of group recruitment year only
    func getGroupsTitles() -> [Section] {
        let semaphore = DispatchSemaphore(value: 0)
        var section: [Section] = []
        loadGroupsTitles { result in
            section = result
            semaphore.signal()
        }
        semaphore.wait()
        return section
    }
}

// MARK: - list of group at year

extension APIManager {
    private func loadStudentGroupEvents(completion: @escaping ([SectionWithLinks]) -> Void) {
        guard let url = URL(string:  UserDefaults.standard.link) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Ошибка при загрузке данных: \(error?.localizedDescription ?? "")")
                completion([])
                return
            }
            
            do {
                let html = String(data: data, encoding: .utf8)
                let doc: Document = try SwiftSoup.parse(html ?? "")
                let panelHeadings = try doc.select("div.panel-heading")
                var sections: [SectionWithLinks] = []
                
                for i in 0..<panelHeadings.count {
                    let panelHeading = panelHeadings[i]
                    
                    if let titleElement = try panelHeading.select("h4.panel-title a").first() {
                        let title = try titleElement.text()
                        var items: [(String, String)] = []
                        
                        // Поиск элементов item в текущем заголовке
                        let panelCollapseId = try titleElement.attr("href").replacingOccurrences(of: "#", with: "")
                        if let panelCollapseElement = try doc.getElementById(panelCollapseId) {
                            let listItems = try panelCollapseElement.select("li.common-list-item")
                            for listItem in listItems {
                                if let tileElement = try listItem.select("div.tile").first(), let colElements = try? tileElement.select("div[class^=col-sm]"), colElements.count >= 2 {
                                    let itemTitle = try colElements[0].text()
                                    let itemLink = try tileElement.attr("onclick").replacingOccurrences(of: "window.location.href='", with: "").replacingOccurrences(of: "'", with: "")
                                    let item = (itemTitle, itemLink)
                                    items.append(item)
                                }
                            }
                        }
                        sections.append(SectionWithLinks(title: title, items: items))
                    }
                }
                completion(sections)
            } catch {
                print("Ошибка при парсинге HTML: \(error)")
                completion([])
            }
        }
        task.resume()
    }
    /// list grops at the year
    func getGroups() -> [SectionWithLinks] {
        let semaphore = DispatchSemaphore(value: 0)
        var section: [SectionWithLinks] = []
        loadStudentGroupEvents { result in
            section = result
            semaphore.signal()
        }
        semaphore.wait()
        return section
    }
}
