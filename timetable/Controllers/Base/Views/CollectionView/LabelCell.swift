//
//  LabelCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.03.2023.
//

import UIKit

class LabelCell: UICollectionViewCell {
    static let reuseIdentifier = "label-cell-reuse-identifier"
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
        // MARK: Not touch(???)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
