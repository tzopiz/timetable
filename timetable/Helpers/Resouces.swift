//
//  Resouces.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit



enum App {
    enum Theme: Int {
        case device
        case light
        case dark
        func getUserInterfaceStyle() -> UIUserInterfaceStyle {
            switch self {
            case .device: return .unspecified
            case .light: return .light
            case .dark: return .dark
            }
        }
    }
    enum Colors {
        static let active   = #colorLiteral(red: 0, green: 0.4800075889, blue: 1, alpha: 1)
        static let inactive = #colorLiteral(red: 0.5731385946, green: 0.614621222, blue: 0.6466889977, alpha: 1)
        
        static let title      = UIColor.label
        static let BlackWhite = UIColor.systemBackground
        
        static let background = UIColor(named: "background")!
        static let secondary  = UIColor(named: "secondary")!
        static let separator  = UIColor(named: "separator")!

        
    }

    enum Strings {
        enum TabBar {
            static func title(for tab: Tabs) -> String {
                switch tab {
                case .overview: return "Расписание"
                case .tasks: return "Задачи"
                case .people: return "Люди"
                case .profile: return "Профиль"
                }
            }
        }

        enum NavBar {
            static let overview = "Сегодня"
            static let tasks  = "Мои задачи"
            static let people = "Люди"
            static let profile = "Профиль"
        }

        enum Session {
            static let navBarStart = "Актуальные"
            static let navBarFinish = "Выполненные"
        }
        enum Tasks {
            static let currentTasks = "Текущие задания"
            static let completedTasks = "Завершенные задания"
        }

        enum Profile {
            static let changeGroup = "Сменить группу"
            static let appearance = "Оформление"
            static let share = "Поделиться"
            static let feedback = "Обратная связь"
            static let aboutApp = "О приложении"
            static let exit = "Выйти"

        }
    }

    enum Images {
        enum TabBar {
            static func icon(for tab: Tabs) -> UIImage? {
                switch tab {
                case .overview: return UIImage(systemName: "note.text")
                case .tasks:    return UIImage(systemName: "list.bullet.rectangle")
                case .people: return UIImage(systemName: "magnifyingglass")
                case .profile: return UIImage(systemName: "person")
                }
            }
        }

        enum Common {
            static let downArrow = #imageLiteral(resourceName: "down_arrow")
            static let add = UIImage(systemName: "plus.circle.fill")
            static let isDoneTask = UIImage(systemName: "checkmark.circle")
            static let isActiveTask = UIImage(systemName: "circle")
        }
        enum Timetable {
            static let clock = UIImage(systemName: "clock")
        }
        enum Overview {
            static let checkmarkNotDone = #imageLiteral(resourceName: "checkmark_not_done")
            static let checkmarkDone = #imageLiteral(resourceName: "checkmark_done")
            static let rightArrow = #imageLiteral(resourceName: "right_arrow")
        }
        enum Profile {
            static let imageProfile = UIImage(systemName: "person.crop.circle")
            static let changeGroup = UIImage(systemName: "person.2.gobackward")
            static let appearance = UIImage(systemName: "gearshape")
            static let share = UIImage(systemName: "square.and.arrow.up")
            static let feedback = UIImage(systemName: "bubble.left")
            static let aboutApp = UIImage(systemName: "info.circle")
            static let exit = UIImage(systemName: "rectangle.portrait.and.arrow.forward")
        }
    }

    enum Fonts {
        static func helveticaNeue(with size: CGFloat) -> UIFont {
            UIFont(name: "HelveticaNeue", size: size) ?? UIFont()
        }
    }
}
