//
//  SettingsCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    static let SettingsCellId = String(describing: SettingsCell.self)
    public let title = UILabel()
    public let stackInfoView = UIStackView()
    public let leftView = UIImageView()
    
    func configure(title: String, type: CellType, image: UIImage) {
        self.title.text = title
        leftView.image = image
        leftView.isUserInteractionEnabled = false
    }
    func isHighlighted() { self.backgroundColor = App.Colors.secondary.withAlphaComponent(0.4) }
    func isUnHighlighted() { self.backgroundColor = App.Colors.BlackWhite }
    
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
        setupView(leftView)
        stackInfoView.addArrangedSubview(title)
    }
    
    func constaintViews() {
        leftView.anchor(left: leadingAnchor, paddingLeft: 16, centerY: centerYAnchor)
        stackInfoView.anchor(left: leftView.trailingAnchor, paddingLeft: 16,
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
