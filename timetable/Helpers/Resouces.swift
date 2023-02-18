//
//  Resouces.swift
//  WorkoutApp
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

enum Tabs: Int, CaseIterable {
    case overview
    case tasks
    case peoples
    case profile
}


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
                case .overview: return ""
                case .tasks:    return ""
                case .peoples: return ""
                case .profile: return ""
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

        enum Settings {}
    }

    enum Images {
        enum TabBar {
            static func icon(for tab: Tabs) -> UIImage? {
                switch tab {
                case .overview: return UIImage(systemName: "note.text")
                case .tasks:    return UIImage(systemName: "list.bullet.rectangle")
                case .peoples: return UIImage(systemName: "magnifyingglass")
                case .profile: return UIImage(systemName: "person")
                }
            }
        }

        enum Common {
            static let downArrow = UIImage(named: "down_arrow")
            static let add = UIImage(named: "add_button")
        }
    }

    enum Fonts {
        static func menloRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Menlo-Regular", size: size) ?? UIFont()
        }
    }
}
