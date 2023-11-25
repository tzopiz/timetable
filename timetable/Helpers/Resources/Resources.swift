//
//  Resources.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

enum App {
    enum Theme: Int {
        case light
        case dark
        case device
        func getUserInterfaceStyle() -> UIUserInterfaceStyle {
            switch self {
            case .light:  return .light
            case .dark:   return .dark
            case .device: return .unspecified
            }
        }
    }
    enum TaskSortKey: Int, CaseIterable {
        case importanceTop
        case importanceDown
        case deadlineTop
        case deadlineDown
        case completed
        case notCompleted
        case none
        var title: String {
            switch self {
            case .importanceTop:    return "Сначала важные"
            case .importanceDown:   return "Сначала неважные"
            case .deadlineTop:      return "Скоро дедлайн"
            case .deadlineDown:     return "Дедлайн не скоро"
            case .completed:        return "Выполненные задачи"
            case .notCompleted:     return "Невыполненные задачи"
            case .none:             return "Все"
            }
        }
    }
}
