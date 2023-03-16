//
//  MTUserDefaults.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 14.03.2023.
//

import Foundation

extension UserDefaults {
    
    var theme: App.Theme {
        get {
            App.Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .device
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
