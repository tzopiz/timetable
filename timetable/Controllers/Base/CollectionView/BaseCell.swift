//
//  SettingsCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit

enum CellType {
    case base
    case profile
    case switcher
    case theme
    case clearCache
}

class BaseCell: UICollectionViewCell {
    
    class var reuseIdentifier: String { return String(describing: BaseCell.self) }
    
    public let title = TTLabel(fontSize: 17)
    public let stackInfoView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    func configure(title: String, type: CellType = .base, backgroundColor color: UIColor? = nil,
                   textAlignment alignment: NSTextAlignment? = nil,
                   textSize size: CGFloat? = nil, cornerRadius: CGFloat = 16) {
        self.title.text = title
        if let color = color { self.backgroundColor = color }
        if let alignment = alignment { self.title.textAlignment = alignment }
        if let size = size { self.title.font = App.Fonts.helveticaNeue(with: size) }
        self.layer.cornerRadius = cornerRadius
    }
    func isHighlighted() { self.alpha = 0.4 }
    func isUnHighlighted() { self.alpha = 1 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        constraintViews()
        configureAppearance()
    }
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupViews()
        constraintViews()
        configureAppearance()
    }
}

@objc
extension BaseCell {
    /// set up subview on cell
    func setupViews() {
        contentView.setupView(stackInfoView)
        stackInfoView.addArrangedSubview(title)
    }
    /// add constaraints to subviews
    func constraintViews() {
        stackInfoView.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor,
                             left: contentView.leadingAnchor, paddingLeft: 16,
                             right: contentView.trailingAnchor, paddingRight: -16)
    }
    /// configre appearence subviews
    func configureAppearance() {
        self.backgroundColor = App.Colors.BlackWhite
    }
}
