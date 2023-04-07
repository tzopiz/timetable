//
//  GroupsViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit

final class GroupsViewController: UITableViewController {
    var completion: (() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GroupCell")
        tableView.backgroundColor = App.Colors.background
    }
}
extension GroupsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupRawData.components(separatedBy: CharacterSet.newlines).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value2, reuseIdentifier: "GroupCell")
        var content = cell.defaultContentConfiguration()
        
        content.text = groupRawData.components(separatedBy: CharacterSet.newlines)[indexPath.row].components(separatedBy: ",").first
        content.textProperties.color = App.Colors.title
        content.textProperties.font = App.Fonts.helveticaNeue(with: 17)
        content.textProperties.numberOfLines = 0
        
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 0
        selectionColor.backgroundColor = App.Colors.secondary.withAlphaComponent(0.4)
        
        cell.contentConfiguration = content
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.backgroundColor = App.Colors.BlackWhite
        cell.selectedBackgroundView = selectionColor
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = App.Colors.BlackWhite
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            UserDefaults.standard.link = "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334102"
        case 1:
            UserDefaults.standard.link = "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334471"
        case 2:
            UserDefaults.standard.link = "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334404"
        case 3:
            UserDefaults.standard.link =  "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334120"
        case 4:
            UserDefaults.standard.link = "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334111"
        case 5:
            UserDefaults.standard.link = "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334488"
        case 6:
            UserDefaults.standard.link = "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/333990"
        case 7:
            UserDefaults.standard.link = "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334477"
        case 8:
            UserDefaults.standard.link = "https://timetable.spbu.ru/AMCP/StudentGroupEvents/Primary/334029"
        default:
            UserDefaults.standard.link = ""
        }
        UserDefaults.standard.group = groupRawData.components(separatedBy: CharacterSet.newlines)[indexPath.row]
        self.navigationController?.popViewController(animated: true)
        completion?()
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .blue
        return indexPath
    }
}
