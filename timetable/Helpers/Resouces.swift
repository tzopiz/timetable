//
//  Resouces.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit



enum App {
    enum Colors {
        static let active = UIColor(hexString: "#437BFE")
        static let inactive = UIColor(hexString: "#929DA5")

        static let background = UIColor(hexString: "#F8F9F9")
        static let separator = UIColor(hexString: "#E8ECEF")
        static let secondary = UIColor(hexString: "#F0F3FF")

        static let titleGray = UIColor(hexString: "#545C77")
    }

    enum Strings {
        enum TabBar {
            static func title(for tab: Tabs) -> String {
                switch tab {
                case .overview: return "Overview"
                case .tasks:    return "Tasks"
                case .people: return "People"
                case .profile: return "Profile"
                }
            }
        }

        enum NavBar {
            static let overview = "Сегодня"
            static let session  = "Мои задачи"
            static let progress = "Люди"
            static let settings = "Профиль"
        }

        enum Session {
            static let navBarStart = "Актуальные"
            static let navBarFinish = "Выполненные"
        }

        enum Progress {
            static let navBarLeft = "..."
            static let navBarRight = "Найти"

        }
        enum Tasks {
            static let currentTasks = "Текущие задания"
            static let completedTasks = "Завершенные задания"
        }

        enum Settings {}
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
            static let downArrow = UIImage(named: "down_arrow")
            static let add = UIImage(systemName: "plus.circle.fill")
            static let isDoneTask = UIImage(systemName: "checkmark.circle")
            static let isActiveTask = UIImage(systemName: "circle")
        }
        enum Overview {
            static let checkmarkNotDone = UIImage(named: "checkmark_not_done")
            static let checkmarkDone = UIImage(named: "checkmark_done")
            static let rightArrow = UIImage(named: "right_arrow")
        }
    }

    enum Fonts {
        static func menloRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Menlo-Regular", size: size) ?? UIFont()
        }
    }
}
