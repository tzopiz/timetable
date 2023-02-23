//
//  TableViewCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 23.02.2023.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    static func configure(_ title: String, with id: String) -> TableViewCell{
        let selectionColor = UIView() as UIView
        let cell = TableViewCell(style: .subtitle, reuseIdentifier: id)

        selectionColor.layer.borderWidth = 0
        selectionColor.layer.borderColor = App.Colors.separator.cgColor
        selectionColor.backgroundColor = App.Colors.separator

        var content = cell.defaultContentConfiguration()
        content.text = title
        content.textProperties.font = App.Fonts.menloRegular(with: 17)
        content.secondaryTextProperties.font = App.Fonts.menloRegular(with: 15)
        content.textProperties.numberOfLines = 0
        content.secondaryTextProperties.numberOfLines = 0
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.selectedBackgroundView = selectionColor
        cell.selectedBackgroundView?.backgroundColor = App.Colors.secondary

        cell.backgroundColor = App.Colors.background
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        return cell
    }
    
}
