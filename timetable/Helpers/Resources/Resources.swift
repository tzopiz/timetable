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
    enum TaskType: Int {
        case active
        case all
        // TODO: rename to sortfilter and add keyes
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
        static let purple   = #colorLiteral(red: 0.5327770114, green: 0.1988949776, blue: 0.9384314418, alpha: 1)
        static let text       = UIColor.dynamic(light: #colorLiteral(red: 0.2221248746, green: 0.256721139, blue: 0.3917680979, alpha: 1), dark: #colorLiteral(red: 0.9718694091, green: 0.9750172496, blue: 0.9750832915, alpha: 1))
        static let text_2     = UIColor.dynamic(light: #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), dark: #colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))
        static let secondary  = UIColor.dynamic(light: #colorLiteral(red: 0.9403048754, green: 0.9514570832, blue: 1, alpha: 1), dark: #colorLiteral(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0))
        static let separator  = UIColor.dynamic(light: #colorLiteral(red: 0.9082805514, green: 0.924728632, blue: 0.9373794794, alpha: 1), dark: #colorLiteral(red: 0.1726317406, green: 0.1726317406, blue: 0.1726317406, alpha: 1))
        static let BlackWhite = UIColor.dynamic(light: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), dark: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        static let background = UIColor.dynamic(light: #colorLiteral(red: 0.9501417279, green: 0.9502555728, blue: 0.9682293534, alpha: 1), dark: #colorLiteral(red: 0.1073041037, green: 0.107375659, blue: 0.1182927862, alpha: 1))
    }
}
