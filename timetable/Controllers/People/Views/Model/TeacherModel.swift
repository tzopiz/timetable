//
//  TeacherModel.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.03.2023.
//

import Foundation

struct Teacher: Codable, Hashable {
    let name: String
    let position: String
    let department: String
    let publications: Int
    let applications: Int
    let grants: Int
    let projects: Int
    let personalLink: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    static func == (lhs: Teacher, rhs: Teacher) -> Bool {
        return lhs.name == rhs.name
    }
    func contains(_ filter: String?) -> Bool {
        guard let filterText = filter else { return true }
        if filterText.isEmpty { return true }
        let lowercasedFilter = filterText.lowercased()
        return name.lowercased().contains(lowercasedFilter)
    }
    
    var description: String {
        return """
        Name: \(name)
        Position: \(position)
        Department: \(department)
        Publications: \(publications)
        Applications: \(applications)
        Grants: \(grants)
        Projects: \(projects)
        Personal Link: \(personalLink)
        =============
        """
    }
}
