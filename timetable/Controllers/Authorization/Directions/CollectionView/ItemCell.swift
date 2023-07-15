//
//  ItemCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 12.07.2023.
//

import UIKit

class ItemCell: UICollectionViewCell {
    static let reuseIdentifier = "ItemCell"
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = App.Colors.text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = App.Fonts.helveticaNeue(with: 17)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.backgroundColor = App.Colors.BlackWhite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
