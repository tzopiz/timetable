//
//  APIManager.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 05.09.2023.
//

import UIKit
import SwiftSoup

final class APIManager {
    static let shared = APIManager()
    private init() { }
}

extension APIManager {
    
    // MARK: - timetable
    
    func loadTimetableData(with firstDay: String?, completion: @escaping (StudyWeek) -> Void) {
        
        let timeInterval: String
        guard let firstDay = firstDay else { return }
        if firstDay == "\(Date())".components(separatedBy: " ")[0] { timeInterval = "" }
        else { timeInterval = "/" + firstDay }
        let url = URL(string: UserDefaults.standard.link + timeInterval)
        guard let url = url else { return }
        var i = 0, educators: [String] = []
        
        // Создаем задачу для загрузки данных с указанным URL и обрабатываем результаты
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            // Проверяем, возникла ли ошибка при загрузке данных и выводим ее в консоль, если она есть
            if let error = error {
                completion(StudyWeek(startDate: "", days: []))
                print("Ошибка при чтении данных: \(error)")
                return
            }
            
            // Если данные загружены успешно и удалось преобразовать их в строку с кодировкой UTF-8
            if let data = data, let html = String(data: data, encoding: .utf8) {
                do {
                    let doc = try SwiftSoup.parse(html),
                        startDateElement = try doc.select("#timetable-week-navigator-chosen-week a"),
                        startDate = try? startDateElement.attr("data-weekmonday")
                    var dayDataArray: [StudyDay] = []
                    
                    for element in try doc.select("div.panel.panel-default") {
                        guard let dateElement = try element.select("div.panel-heading > h4.panel-title").first()
                        else { continue }
                        
                        let date = try dateElement.text().trimmingCharacters(in: .whitespacesAndNewlines)
                        var lessons: [Lesson] = []
                        
                        for lessonElement in try element.select("ul.panel-collapse > li.common-list-item") {
                            let time = try lessonElement.select("div.studyevent-datetime > div.with-icon > div > span.moreinfo").first()?.text() ?? ""
                            
                            var name: String!
                            if let nameElement = try lessonElement.select("div.studyevent-subject > div.with-icon > div > span.moreinfo").first() {
                                name = try nameElement.text()
                                var details = ""
                                
                                if let detailsElement = try doc.select("div.studyevent-subject > div.with-icon:nth-child(2) > div > span").first() {
                                    details = try detailsElement.text()
                                    name = name + "\n" + details
                                }
                            }

                            let location = try lessonElement.select("div.studyevent-locations > div.with-icon > div.address-modal-btn > span.hoverable.link, div.col-sm-3.studyevent-multiple-locations").first()?.text() ?? ""
                            
                            var teacher = ""
                            if let educatorElement = try lessonElement.select("div.studyevent-educators > div.with-icon > div > div > span > span > a, div.studyevent-educators > div.with-icon > div > span.hoverable > span > a").first() {
                                teacher = try educatorElement.text()
                            } else {
                                if i == 0 {
                                    let educatorElements = try doc.select("div.studyevent-educators > div.with-icon > div.locations-educators-modal-btn > span.hoverable.link")
                                    for educatorElement in educatorElements {
                                        let teachers = try educatorElement.text()
                                        educators.append(teachers)
                                    }
                                }
                                if i < educators.count {
                                    teacher = educators[i]
                                    i += 1
                                } else { teacher = "error" }
                            }
                            
                            let isCancelled = try lessonElement.select("div.studyevent-subject > div.with-icon > div > span.moreinfo.cancelled").first() != nil
                            
                            let lesson = Lesson(time: time, name: name, location: location, teacher: teacher, isCancelled: isCancelled)
                            lessons.append(lesson)
                        }
                        let schoolDay = StudyDay(date: date, lessons: lessons)
                        dayDataArray.append(schoolDay)
                    }
                    
                    // Вызываем завершающее замыкание с объектом schoolWeek
                    let schoolWeek = StudyWeek(startDate: Date().getMonthChanges(for: startDate),
                                               days: dayDataArray).addingFreeDays(firstDay)
                    completion(schoolWeek)
                } catch { print("Ошибка при разборе HTML: \(error)") }
            }
        }.resume()
    }
    
    // MARK: - list of faculties
    
    func loadFaculties(completion: @escaping ([(text: String, link: String)]) -> Void) {
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
                    var elementArray: [(text: String, link: String)] = []
                    
                    for liElement in liElements {
                        if let aElement = try liElement.select("a").first(),
                           let href = try? aElement.attr("href"), !href.isEmpty,
                           let text = try? aElement.text(), !text.isEmpty {
                            elementArray.append((text: text, link: href))
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
    
    // MARK: - list of directions + title for headerView of list directions
    
    func loadDirectionsTitles(completion: @escaping ([String]) -> Void) {
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
    
    func loadTitle(completion: @escaping (String?) -> Void) {
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
    
    // MARK: - only years of groups
    
    func loadGroupsTitles(completion: @escaping ([[Auth.SectionWithLinks]]) -> Void) {
        guard let url = URL(string: UserDefaults.standard.link) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Ошибка при загрузке данных: \(error?.localizedDescription ?? "")")
                completion([])
                return
            }
            
            do {
                let html = String(data: data, encoding: .utf8)
                let doc: Document = try SwiftSoup.parse(html ?? "")
                let listItems = try doc.select("li.common-list-item.row")
                var sections: [[Auth.SectionWithLinks]] = []
                var currentSection: [Auth.SectionWithLinks] = []
                
                for listItem in listItems {
                    // Извлечение значения заголовка
                    if let titleElement = try listItem.select("div.col-sm-5").first() {
                        let title = try titleElement.text()
                        if title == "Образовательная программа" || title == "Educational programme" {
                            if !currentSection.isEmpty {
                                sections.append(currentSection)
                                currentSection = []
                            }
                            continue
                        }
                        // Извлечение значений элементов списка
                        let listElements = try listItem.select("a")
                        var sectionItems: [(text: String, link: String)] = []
                        for listElement in listElements {
                            let text = try listElement.text() // Значение текста элемента
                            let link = try listElement.attr("href") // Значение ссылки элемента
                            sectionItems.append((text: text, link: link)) // Добавление пары (текст, ссылка) в sectionItems
                        }
                        currentSection.append(Auth.SectionWithLinks(title: title, items: sectionItems))
                    }
                }
                if !currentSection.isEmpty {
                    sections.append(currentSection)
                    currentSection = []
                }
                completion(sections)
            } catch {
                print("Ошибка при парсинге HTML: \(error)")
                completion([])
            }
        }.resume()
    }
    
    // MARK: - list of group at year
    
    func loadStudentGroupEvents(completion: @escaping ([Auth.SectionWithLinks]) -> Void) {
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
                var sections: [Auth.SectionWithLinks] = []
                
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
                        sections.append(Auth.SectionWithLinks(title: title, items: items))
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
}
