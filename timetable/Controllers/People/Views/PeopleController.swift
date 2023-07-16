//
//  PeopleController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class PeopleController {
    func filteredPeople(with filter: String? = nil, limit: Int? = nil) -> [Teacher] {
        generatePeople()
        guard let filter = filter else { return people }
        if filter == "" { return people }
        let filtered = people.filter { $0.name.contains(filter) }
        if let limit = limit {
            return Array(filtered.prefix(through: limit))
        } else { return filtered }
    }
    private lazy var people: [Teacher] = []
}

extension PeopleController {
    private func generatePeople() {
        APIManager.shared.getTeachres { [weak self] teashers in
            DispatchQueue.global().async {
                guard let self = self else { return }
                self.people = teashers
            }
        }
    }

}
