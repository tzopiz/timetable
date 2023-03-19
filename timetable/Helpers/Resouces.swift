//
//  Resouces.swift
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
    enum TaskType: Int {
        case active
        case all
        func getUserTaskType() -> TaskType {
            switch self {
            case .all:    return .all
            case .active: return .active
            }
        }
    }
    enum Colors {
        static let red      = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        static let active   = #colorLiteral(red: 0, green: 0.4800075889, blue: 1, alpha: 1)
        static let inactive = #colorLiteral(red: 0.5731385946, green: 0.614621222, blue: 0.6466889977, alpha: 1)
        static let title      = UIColor.dynamic(light: #colorLiteral(red: 0.2221248746, green: 0.256721139, blue: 0.3917680979, alpha: 1), dark: #colorLiteral(red: 0.9718694091, green: 0.9750172496, blue: 0.9750832915, alpha: 1))
        static let secondary  = UIColor.dynamic(light: #colorLiteral(red: 0.9403048754, green: 0.9514570832, blue: 1, alpha: 1), dark: #colorLiteral(red: 0.6777015328, green: 0.714448154, blue: 0.8574965596, alpha: 1))
        static let separator  = UIColor.dynamic(light: #colorLiteral(red: 0.9082805514, green: 0.924728632, blue: 0.9373794794, alpha: 1), dark: #colorLiteral(red: 0.1726317406, green: 0.1726317406, blue: 0.1726317406, alpha: 1))
        static let BlackWhite = UIColor.dynamic(light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        static let background = UIColor.dynamic(light: #colorLiteral(red: 0.9718694091, green: 0.9750172496, blue: 0.9750832915, alpha: 1), dark: #colorLiteral(red: 0.1409981251, green: 0.1364274919, blue: 0.1622747779, alpha: 1))
    }

    enum Strings {
        static let overview = "Сегодня"
        static let tasks    = "Мои задачи"
        static let people   = "Люди"
        static let profile  = "Профиль"
        
        static let navBarStart    = "Актуальные"
        static let navBarFinish   = "Выполненные"
        static let currentTasks   = "Текущие задания"
        static let completedTasks = "Завершенные задания"
        
        static let changeGroup = "Сменить группу"
        static let appearance  = "Оформление"
        static let share       = "Поделиться"
        static let feedback    = "Обратная связь"
        static let aboutApp    = "О приложении"
        static let exit        = "Выйти"
        
        static let warning = "⚠️"
        static let exclamation_1 = "❗️"
        static let exclamation_2 = "‼️"
        static let exclamation_3 = "💀"
    }

    enum Images {
        static func icon(for tab: Tabs) -> UIImage? {
            switch tab {
            case .overview: return UIImage(systemName: "note.text")
            case .tasks:    return UIImage(systemName: "list.bullet.rectangle")
            case .people:   return UIImage(systemName: "person")
            case .profile:  return UIImage(systemName: "line.3.horizontal.circle")
            }
        }
        static let clock = #imageLiteral(resourceName: "clock@256")
        
        static let downArrow = #imageLiteral(resourceName: "chevron_down@256x")
        static let addButton = #imageLiteral(resourceName: "plus.circle.fill@256x.png")
        
        static let checkmarkDone    = #imageLiteral(resourceName: "checkmark_circle@256x")
        static let checkmarkNotDone = #imageLiteral(resourceName: "circle@256x.png")
        
        static let theme        = #imageLiteral(resourceName: "theme")
        static let imageProfile = #imageLiteral(resourceName: "person_crop_circle_fill@256x")
        static let changeGroup  = #imageLiteral(resourceName: "person_2_gobackward@256x")
        static let share        = #imageLiteral(resourceName: "square_and_arrow_up@256x")
        static let aboutApp     = #imageLiteral(resourceName: "info_circle@256x")
        static let exit         = #imageLiteral(resourceName: "rectangle_portrait_and_arrow_forward@256x")
        
        static let warning = #imageLiteral(resourceName: "warning@128")
        static let exclamation_1 = #imageLiteral(resourceName: "warning_1@64")
        static let exclamation_2 = #imageLiteral(resourceName: "warning_2@64")
        static let exclamation_3 = #imageLiteral(resourceName: "warning_3@64")
    }

    enum Fonts {
        static func helveticaNeue(with size: CGFloat) -> UIFont {
            UIFont(name: "HelveticaNeue", size: size) ?? UIFont()
        }
    }
}
