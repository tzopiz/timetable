//
//  Data.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import Foundation

struct Direction {
    let name: String
    let items: [String]
}
struct Faculty {
    let header: String
    let directions: [Direction]
}
