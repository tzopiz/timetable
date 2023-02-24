//
//  TableViewCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 23.02.2023.
//

import UIKit

let id = "cell"

class TableViewCell: UITableViewCell {
    
    private let tableViewCellView = TableViewCellView()
    let tableViewHeight: CGFloat = 130
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let selectionColor = UIView() as UIView
        self.selectedBackgroundView = selectionColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.selectedBackgroundView?.backgroundColor = App.Colors.active.withAlphaComponent(0.2)
        self.backgroundView = tableViewCellView
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContent(with title: String = "", secondaryText: String = "", details: String = "") {
        tableViewCellView.configureContent(title: title, subtitle: secondaryText, details: details)
    }
}
