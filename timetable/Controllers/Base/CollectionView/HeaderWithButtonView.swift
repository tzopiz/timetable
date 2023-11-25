//
//  HeaderWithButtonView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 12.07.2023.
//

import UIKit

final class HeaderWithButtonView: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: HeaderWithButtonView.self)
    
    private let titleLabel = TTLabel(fontSize: 19)
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
        addSubview(stackView)
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
        let image = isOpen ? UIImage(systemName: "chevron.down") : UIImage(systemName: "minus")
        UIView.transition(with: expandButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.expandButton.setImage(image, for: .normal)
        })
        expandButton.addButtonTarget(target: target, action: action)
    }
}
