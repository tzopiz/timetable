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
    case exit
    case theme
}

class BaseCell: UICollectionViewCell {
    static let SettingsCellId = String(describing: BaseCell.self)
    public let title = UILabel()
    public let stackInfoView = UIStackView()
    
    func configure(title: String, type: CellType = .base, image: UIImage? = nil,
                    backgroundColor color: UIColor? = nil, textAlignment alignment: NSTextAlignment? = nil,
                   textSize size: CGFloat? = nil) {
        self.title.text = title
        if let color = color { self.backgroundColor = color }
        if let alignment = alignment { self.title.textAlignment = alignment }
        if let size = size { self.title.font = App.Fonts.helveticaNeue(with: size) }
    }
    func isHighlighted() { self.alpha = 0.4 }
    func isUnHighlighted() { self.alpha = 1 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        constaintViews()
        configureAppearance()
    }
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupViews()
        constaintViews()
        configureAppearance()
    }
    func setupViews() {
        setupView(stackInfoView)
        stackInfoView.addArrangedSubview(title)
    }
    
    func constaintViews() {
        stackInfoView.anchor(left: leadingAnchor, paddingLeft: 16,
                             right: trailingAnchor, paddingRight: -16,
                             centerY: centerYAnchor)
        title.setDimensions(height: 40)
    }
    
    func configureAppearance() {
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 20
        
        title.font = App.Fonts.helveticaNeue(with: 17)
        title.textColor = App.Colors.title
        title.textAlignment = .left
        title.numberOfLines = 0
        
        stackInfoView.spacing = 2
        stackInfoView.axis = .horizontal
        stackInfoView.distribution = .fillEqually
    }
}
