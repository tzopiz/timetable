//
//  APIManager Teachers.swift
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
                        let teacher = Teacher(name: name, position: position,
                                              department: department, publications: publications,
                                              applications: applications, grants: grants,
                                              projects: projects, personalLink: link)
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
    
    // MARK: - TeacherInfo
    
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
                var sections: [Auth.Section] = []
                
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
    private func parseSection(sectionTag: Element) throws -> Auth.Section {
        let title = sectionTag.ownText()
        
        // Check if the section has a description list (dl) element
        if let dlElement = try sectionTag.nextElementSibling()?.select("dl").first() {
            let dtElements = try dlElement.select("dt")
            let items = try dtElements.map { dtElement -> String in
                let itemText = try dtElement.text()
                return itemText
            }
            return Auth.Section(title: title, items: items)
        }
        
        // If there is no description list, parse as usual
        let sectionList = try sectionTag.nextElementSibling()?.select("p")
        var items: [String] = []
        for item in sectionList ?? Elements() {
            let itemText = try item.text()
            items.append(itemText)
        }
        return Auth.Section(title: title, items: items)
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

