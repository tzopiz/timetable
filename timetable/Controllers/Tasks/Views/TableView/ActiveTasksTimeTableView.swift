//
//  ActiveTasksTimeTableView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.02.2023.
//

import UIKit



final class ActiveTasksTimeTableView: TTBaseTableView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return activeTasks.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewCell().tableViewHeight
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewCell(style: .default, reuseIdentifier: id)
        cell.configureContent(
            with: "qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.",
            secondaryText: "qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.",
            details: "qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.qwertyuiopasdfghjkl;zxcvbnm,.)")
        return cell
    }
    
}
