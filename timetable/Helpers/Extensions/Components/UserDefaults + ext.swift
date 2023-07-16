//
//  UserDefaults + ext.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 14.03.2023.
//

import Foundation

extension UserDefaults {
    var theme: App.Theme {
        get { App.Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .device }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme") }
    }
    var taskType: App.TaskType {
        get { App.TaskType(rawValue: UserDefaults.standard.integer(forKey: "selectedTaskType")) ?? .all }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTaskType") }
    }
    var group: String {
        get { UserDefaults.standard.string(forKey: "currentGorp") ?? "select a group" }
        set { UserDefaults.standard.set(newValue, forKey: "currentGorp") }
    }
    var link: String { // https://timetable.spbu.ru
        get { UserDefaults.standard.string(forKey: "link") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "link") }
    }
    var registered: Bool {
        get { UserDefaults.standard.bool(forKey: "registered") }
        set { UserDefaults.standard.set(newValue, forKey: "registered") }
    }
}
