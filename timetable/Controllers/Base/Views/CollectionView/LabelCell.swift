//
//  LabelCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.03.2023.
//

import UIKit

class LabelCell: UICollectionViewCell {
    static let reuseID =  String(describing: LabelCell.self)
    let label = UILabel()
    let sublabel = UILabel()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension LabelCell {
    func configure() {
        let inset = CGFloat(16)
        backgroundColor = App.Colors.BlackWhite
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(sublabel)
        contentView.addSubview(stackView)
        
        label.font = App.Fonts.helveticaNeue(with: 17)
        label.adjustsFontForContentSizeCategory = true
        
        sublabel.font = App.Fonts.helveticaNeue(with: 15)
        sublabel.adjustsFontForContentSizeCategory = true
        
        layer.cornerRadius = 20
        stackView.anchor(left: contentView.leadingAnchor, paddingLeft: inset,
                         right: contentView.trailingAnchor, paddingRight: -inset,
                         centerY: contentView.centerYAnchor)
    }
}
