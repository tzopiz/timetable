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
