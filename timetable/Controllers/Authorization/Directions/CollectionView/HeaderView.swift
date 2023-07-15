//
//  HeaderView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 12.07.2023.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: HeaderView.self)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = App.Colors.text
        label.font = App.Fonts.helveticaNeue(with: 19)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let expandButton: TTButton = {
        let button = TTButton(with: .secondary)
        return button
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(expandButton)
        
        stackView.anchor(top: topAnchor, bottom: bottomAnchor,
                         left: leadingAnchor, paddingLeft: 16,
                         right: trailingAnchor, paddingRight: -16)
        
        expandButton.setDimensions(width: 32)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with text: String, status isOpen: Bool, tag: Int, target: Any?, action: Selector) {
        titleLabel.text = text
        expandButton.tag = tag
        expandButton.setImage(isOpen ? UIImage(systemName: "chevron.down") : UIImage(systemName: "minus"), for: .normal)
        expandButton.addButtonTarget(target: target, action: action)
    }
}
