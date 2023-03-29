//
//  TeacherModel.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.03.2023.
//

import Foundation

struct Teacher: Codable, Hashable {
    var name: String
    var info: String
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
        return name.lowercased().contains(lowercasedFilter) || info.lowercased().contains(lowercasedFilter)
    }
}
