//
//  ProfileCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//

import UIKit

final class ProfileCell: SettingsCell {
    
    static let ProfileCellId = String(describing: ProfileCell.self)
    private let subtitle = UILabel()
    private let leftViewButton = TTButton(with: .secondary)
    
    override func configure(title: String, type: CellType, image: UIImage) {
        super.configure(title: title, type: type, image: image)
        self.subtitle.text = UserDefaults.standard.group.components(separatedBy: ",").first
        self.leftView.image = image
        stackInfoView.axis = .vertical
        stackInfoView.spacing = 10
        stackInfoView.addArrangedSubview(subtitle)
        leftViewButton.setDimensions(height: 88, width: 88)
        leftViewButton.addButtonTarget(target: self, action: #selector(changePhotoProfile))
    }
    
    @objc func changePhotoProfile() {
        // TODO: chabge photo profile
    }
    override func configureAppearance() {
        super.configureAppearance()
        leftView.setDimensions(height: 88, width: 88)
        subtitle.font = App.Fonts.helveticaNeue(with: 15)
        subtitle.textColor = App.Colors.inactive
        subtitle.textAlignment = .left
        subtitle.numberOfLines = 0
    }
    override func constaintViews() {
        leftView.anchor(left: leadingAnchor, paddingLeft: 16, centerY: centerYAnchor)
        title.setDimensions(height: 40)
        stackInfoView.anchor(left: leftView.trailingAnchor, paddingLeft: 16,
                             right: trailingAnchor, paddingRight: -16,
                             centerY: centerYAnchor)
    }
}
