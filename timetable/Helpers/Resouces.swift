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

        enum Settings {
            static let changeGroup = "Сменить группу"
            static let appearance = "Оформление"
            static let share = "Поделиться"
            static let feedback = "Обратная связь"
            static let aboutApp = "О приложении"

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
        enum Profile {
            static let imageProfile = UIImage(systemName: "person.crop.circle")
            static let changeGroup = UIImage(systemName: "person.2.gobackward")
            static let appearance = UIImage(systemName: "gearshape")
            static let share = UIImage(systemName: "square.and.arrow.up")
            static let feedback = UIImage(systemName: "bubble.left")
            static let aboutApp = UIImage(systemName: "info.circle")


        }
    }

    enum Fonts {
        static func menloRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Menlo-Regular", size: size) ?? UIFont()
        }
    }
}
