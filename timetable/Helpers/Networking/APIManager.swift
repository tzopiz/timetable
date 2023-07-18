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
    private init() { }
    
}
extension APIManager {
    func getTeachers(completion: @escaping ([Teacher]?, Error?) -> Void) {
        let urlString = "https://apmath.spbu.ru/studentam/spisok-i-rejting-prepodavatelej.html"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data, let html = String(data: data, encoding: .utf8) else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTML data"]))
                return
            }
            
            do {
                let doc = try SwiftSoup.parse(html)
                
                var teachers: [Teacher] = []
                
                let rows = try doc.select("tr")
                for row in rows {
                    let columns = try row.select("td")
                    
                    if columns.count == 7 {
                        let name = try columns[0].text()
                        let position = try columns[1].text()
                        let department = try columns[2].text()
                        let publications = try Int(columns[3].text()) ?? 0
                        let applications = try Int(columns[4].text()) ?? 0
                        let grants = try Int(columns[5].text()) ?? 0
                        let projects = try Int(columns[6].text()) ?? 0
                        let personalLink = try columns[0].select("a").attr("href")
                        let link = "https://apmath.spbu.ru" + personalLink
                        let teacher = Teacher(name: name, position: position, department: department, publications: publications, applications: applications, grants: grants, projects: projects, personalLink: link)
                        teachers.append(teacher)
                    }
                }
                teachers.removeFirst()
                completion(teachers, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    func getListOfTeachers() -> [Teacher] {
        let semaphore = DispatchSemaphore(value: 0)
        var elements: [Teacher] = []
        getTeachers { (result, error) in
            if let result = result {
                elements = result
            } else {
                print("getListOfTeachers error: \(String(describing: error))")
            }
            semaphore.signal()
        }
        semaphore.wait()
        return elements
    }
    
    func fetchTeacherInfo(link: String, completion: @escaping (TeacherInfo) -> Void) {
        guard let url = URL(string: link) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                  let data = data,
                  let html = String(data: data, encoding: .utf8) else {
                return
            }
            
            self.parseTeacherInfo(html: html) { teacherInfo in
                completion(teacherInfo)
            }
        }.resume()
    }
    
    // Функция для парсинга HTML и возврата объекта TeacherInfo через замыкание
    private func parseTeacherInfo(html: String, completion: @escaping (TeacherInfo) -> Void) {
        DispatchQueue.global().async {
            do {
                let doc: Document = try SwiftSoup.parse(html)
                
                // Извлечение данных и заполнение объекта teacherInfo
                
                // Имя преподавателя
                let nameTag = try doc.select("h1").first()
                let name = try nameTag?.text() ?? ""
                
                // Должность и дополнительная информация
                let positionTag = try doc.select("div.tm-main p").first()
                let position = positionTag?.ownText() ?? ""
                let additionalInfo = try positionTag?.text() ?? ""
                
                // Ссылки
                var links: [String] = []
                let linksTags = try doc.select("div.tm-main p a")
                for linkTag in linksTags {
                    if let link = try? linkTag.attr("href") {
                        links.append(link)
                    }
                }
                
                // Объединение секций
                var sections: [Section] = []
                
                // Секции с h2.trigger
                let sectionTags = try doc.select("h2.trigger")
                for sectionTag in sectionTags {
                    let section = try self.parseSection(sectionTag: sectionTag)
                    sections.append(section)
                }
                
                // Создание объекта TeacherInfo
                let teacherInfo = TeacherInfo(
                    name: name,
                    position: position,
                    additionalInfo: additionalInfo,
                    links: links,
                    sections: sections
                )
                
                // Возврат результата через замыкание
                DispatchQueue.main.async {
                    completion(teacherInfo)
                }
            } catch {
                print("Error parsing HTML: \(error)")
            }
        }
    }
    func parseSection(sectionTag: Element) throws -> Section {
        let title = sectionTag.ownText()
        
        // Check if the section has a description list (dl) element
        if let dlElement = try sectionTag.nextElementSibling()?.select("dl").first() {
            let dtElements = try dlElement.select("dt")
            let items = try dtElements.map { dtElement -> String in
                let itemText = try dtElement.text()
                return itemText
            }
            return Section(title: title, items: items)
        }
        
        // If there is no description list, parse as usual
        let sectionList = try sectionTag.nextElementSibling()?.select("p")
        var items: [String] = []
        for item in sectionList ?? Elements() {
            let itemText = try item.text()
            items.append(itemText)
        }
        return Section(title: title, items: items)
    }
    func getImageURL(from websiteURL: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: websiteURL) else {
            print("Некорректный URL.")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data, let html = String(data: data, encoding: .utf8) else {
                print("Ошибка при загрузке HTML: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                completion(nil)
                return
            }
            
            do {
                let html = try String(contentsOf: url)
                let doc = try SwiftSoup.parse(html)
                let imageElements = try doc.select("img")
                if let imageUrl = try? imageElements[2].attr("src") {
                    completion("https://apmath.spbu.ru" + imageUrl)
                }
            } catch {
                print("Ошибка при парсинге HTML: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }

    func loadImage(from imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            print("Некорректный URL.")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                print("Ошибка при загрузке изображения: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                completion(nil)
                return
            }
            if let image = UIImage(data: data) { completion(image) }
            else {
                print("Ошибка при создании изображения из данных.")
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Данные изображения: \(dataString)")
                }
                completion(nil)
            }
        }
        
        task.resume()
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
            // Создаем задачу для загрузки данных с указанным URL и обрабатываем результаты
            
            if let error = error {
                completion(StudyWeek(startDate: "", days: []))
                print("Ошибка при чтении данных: \(error)")
                return
            }
            // Проверяем, возникла ли ошибка при загрузке данных и выводим ее в консоль, если она есть
            
            if let data = data, let html = String(data: data, encoding: .utf8) {
                // Если данные загружены успешно и удалось преобразовать их в строку с кодировкой UTF-8
                
                do {
                    let doc = try SwiftSoup.parse(html)
                    // Создаем экземпляр SwiftSoup и парсим HTML
                    let startDateElement = try doc.select("#timetable-week-navigator-chosen-week a")
                    // Выбираем элемент с определенным ID
                    let startDate = try? startDateElement.attr("data-weekmonday")
                    // Извлекаем значение атрибута
                    var dayDataArray: [StudyDay] = []
                    // Создаем пустой массив StudyDay
                    
                    for element in try doc.select("div.panel.panel-default") {
                        // Итерируемся по элементам с определенным CSS-селектором
                        guard let dateElement = try element.select("div.panel-heading > h4.panel-title").first() else {
                            continue
                        }
                        // Проверяем наличие элемента и его структуру
                        let date = try dateElement.text().trimmingCharacters(in: .whitespacesAndNewlines)
                        // Извлекаем текст и обрезаем лишние пробелы и символы новой строки
                        var lessons: [Lesson] = []
                        // Создаем пустой массив Lesson
                        
                        for lessonElement in try element.select("ul.panel-collapse > li.common-list-item") {
                            // Итерируемся по элементам с определенным CSS-селектором
                            
                            let time = try lessonElement.select("div.studyevent-datetime > div.with-icon > div > span.moreinfo").first()?.text() ?? ""
                            // Извлекаем текст из элемента или используем пустую строку по умолчанию
                            
                            let name = try lessonElement.select("div.studyevent-subject > div.with-icon > div > span.moreinfo").first()?.text() ?? ""
                            // Извлекаем текст из элемента или используем пустую строку по умолчанию
                            
                            let location = try lessonElement.select("div.studyevent-locations > div.with-icon > div.address-modal-btn > span.hoverable.link").first()?.text() ?? ""
                            // Извлекаем текст из элемента или используем пустую строку по умолчанию
                            
                            var teacher = ""
                            if let educatorElement = try lessonElement.select("div.studyevent-educators > div.with-icon > div > div > span > span > a").first() {
                                teacher = try educatorElement.text()
                            } else if let educatorElement = try lessonElement.select("div.studyevent-educators > div.with-icon > div > span.hoverable > span > a").first() {
                                teacher = try educatorElement.text()
                            }
                            // Извлекаем текст преподавателя из элементов или используем пустую строку по умолчанию
                            
                            let isCancelled = try lessonElement.select("div.studyevent-subject > div.with-icon > div > span.moreinfo.cancelled").first() != nil
                            // Проверяем наличие элемента с классом "cancelled"
                            
                            let lesson = Lesson(time: time, name: name, location: location, teacher: teacher, isCancelled: isCancelled)
                            lessons.append(lesson)
                        }
                        let schoolDay = StudyDay(date: date, lessons: lessons)
                        dayDataArray.append(schoolDay)
                    }
                    
                    let schoolWeek = StudyWeek(startDate: Date().getMonthChanges(for: startDate), days: dayDataArray)
                    completion(schoolWeek)
                    // Вызываем завершающее замыкание с объектом schoolWeek
                } catch { print("Ошибка при разборе HTML: \(error)") }
                // Обрабатываем ошибку при разборе HTML и выводим ее в консоль
            }
        }.resume()
    }
}


// MARK: - list of faculties

extension APIManager {
    private func loadFaculties(completion: @escaping ([(text: String, link: String)]) -> Void) {
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
    /// name of Faculties
    func getFaculties() -> [(text: String, link: String)] {
        let semaphore = DispatchSemaphore(value: 0)
        var elements: [(text: String, link: String)] = []
        loadFaculties { result in
            elements = result
            semaphore.signal()
        }
        semaphore.wait()
        return elements
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
    private func loadGroupsTitles(completion: @escaping ([[SectionWithLinks]]) -> Void) {
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
                var sections: [[SectionWithLinks]] = []
                var currentSection: [SectionWithLinks] = []
                
                for listItem in listItems {
                    // Извлечение значения заголовка
                    if let titleElement = try listItem.select("div.col-sm-5").first() {
                        let title = try titleElement.text()
                        if title == "Образовательная программа" {
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
                        currentSection.append(SectionWithLinks(title: title, items: sectionItems))
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
    /// list of group recruitment year only
    func getGroupsTitles() -> [[SectionWithLinks]] {
        let semaphore = DispatchSemaphore(value: 0)
        var section: [[SectionWithLinks]] = []
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
