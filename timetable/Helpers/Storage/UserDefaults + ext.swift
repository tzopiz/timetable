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
    var taskSortKey: App.TaskSortKey {
        get { App.TaskSortKey(rawValue: UserDefaults.standard.integer(forKey: "taskSortKey")) ?? .none }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "taskSortKey") }
    }
    var group: String {
        get { UserDefaults.standard.string(forKey: "currentGorp") ?? "select a group" }
        set { UserDefaults.standard.set(newValue, forKey: "currentGorp") }
    }
    var link: String { // https://timetable.spbu.ru
        get { UserDefaults.standard.string(forKey: "link") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "link") }
    }
    var groupsLink: String {
        get { UserDefaults.standard.string(forKey: "groupsLink") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "groupsLink") }
    }
    var registered: Bool {
        get { UserDefaults.standard.bool(forKey: "registered") }
        set { UserDefaults.standard.set(newValue, forKey: "registered") }
    }
    var CachingTimetable: Bool {
        get { UserDefaults.standard.bool(forKey: "CachingTimetable") }
        set { UserDefaults.standard.set(newValue, forKey: "CachingTimetable") }
    }
}
