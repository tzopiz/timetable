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
    enum Images {
        static func icon(for tab: Tabs) -> UIImage? {
            switch tab {
            case .overview: return UIImage(systemName: "house")
            case .tasks:    return UIImage(systemName: "list.bullet.rectangle")
            case .profile:  return UIImage(systemName: "gear")
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
    enum Strings {
        
        // MARK: Overview
        
        static let overview = "Сегодня"
        
        // MARK: Tasks
        
        static let tasks    = "Мои задачи"
        static let activeTask     = "Активаная задача"
        static let completeTask   = "Выполненная задача"
        static let newTask        = "Новая задача"
        static let navBarStart    = "Актуальные"
        static let navBarFinish   = "Выполненные"
        static let untitle        = "Безымянная"
        static let currentTasks   = "Текущие задания"
        static let completedTasks = "Завершенные задания"
        
        // MARK: Profile
        
        static let profile     = "Профиль"
        static let changeGroup = "Сменить группу"
        static let appearance  = "Оформление"
        static let share       = "Поделиться"
        static let feedback    = "Обратная связь"
        static let aboutApp    = "О приложении"
        static let exit        = "Выйти"
        static let clearCache  = "Очистить кеш"
        static let cacheMode   = "Кешировать расписание"
        
        static let vk_link     = "https://vk.com/tzopiz"
        static let tg_link     = "https://t.me/tzopiz"
        static let github_link = "https://github.com/tzopiz"
        
    }
}
