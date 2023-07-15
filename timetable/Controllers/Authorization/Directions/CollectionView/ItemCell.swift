//
//  ItemCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 12.07.2023.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: ItemCell.self)
    
    private let textLabel: UILabel = {
        let label = UILabel()
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
        contentView.backgroundColor = App.Colors.BlackWhite
        
        textLabel.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor,
                         left: contentView.leadingAnchor, paddingLeft: 16,
                         right: contentView.trailingAnchor, paddingRight: -16)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(_ text: String) { textLabel.text = text }
}
