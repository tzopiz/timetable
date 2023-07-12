//
//  CurrentLink.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 12.07.2023.
//

import Foundation

class CurrentLink {
    static let shared = CurrentLink()
    var link = "https://timetable.spbu.ru"
    private init() {}
}
