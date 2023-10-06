//
//  ModelAuth.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 16.07.2023.
//

import UIKit

struct Auth {
    struct Section {
        let title: String
        var items: [String]
    }
    
    struct SectionWithLinks {
        let title: String
        let items: [(text: String, link: String)]
        var isExpanded: Bool = false
    }
}
extension Auth.Section: CustomStringConvertible {
    var description: String {
        let titleDescription = "Title: \(title)"
        let itemsDescription = "Items:\n\(itemsDescriptionIndented)"
        return """
    Section:
    \(titleDescription)
    \(itemsDescription)
    """
    }
    
    private var itemsDescriptionIndented: String {
        let indentation = "    "
        let indentedItems = items.map { indentation + $0 }
        return indentedItems.joined(separator: "\n")
    }
}

extension Auth.SectionWithLinks: CustomStringConvertible {
    var description: String {
        let titleDescription = "Title: \(title)"
        let itemsDescription = "Items:\n\(itemsDescriptionIndented)"
        let isExpandedDescription = "Is Expanded: \(isExpanded)"
        return """
    Section with Links:
    \(titleDescription)
    \(itemsDescription)
    \(isExpandedDescription)
    """
    }
    
    private var itemsDescriptionIndented: String {
        let indentation = "    "
        let indentedItems = items.map { "\(indentation)- \($0.text): \($0.link)" }
        return indentedItems.joined(separator: "\n")
    }
}
