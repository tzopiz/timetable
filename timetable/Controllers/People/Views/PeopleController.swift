//
//  PeopleController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

class PeopleController {
    struct People: Hashable {
        let name: String
        let info: String
        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        static func == (lhs: People, rhs: People) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        func contains(_ filter: String?) -> Bool {
            guard let filterText = filter else { return true }
            if filterText.isEmpty { return true }
            let lowercasedFilter = filterText.lowercased()
            return name.lowercased().contains(lowercasedFilter) || info.lowercased().contains(lowercasedFilter)
        }
    }
    func filteredMountains(with filter: String? = nil, limit: Int? = nil) -> [People] {
        let filtered = people.filter { $0.contains(filter) }
        if let limit = limit {
            return Array(filtered.prefix(through: limit))
        } else {
            return filtered
        }
    }
    private lazy var people: [People] = {
        return generateMountains()
    }()
}

extension PeopleController {
    private func generateMountains() -> [People] {
        let components = peopleRawData.components(separatedBy: CharacterSet.newlines)
        var people = [People]()
        for line in components {
            let peopleComponents = line.components(separatedBy: ",")
            let name = peopleComponents[0]
            let info = peopleComponents[1]
            people.append(People(name: name, info: info))
        }
        return people
    }

}
