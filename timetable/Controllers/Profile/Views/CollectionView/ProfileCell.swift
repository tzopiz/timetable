//
//  ProfileCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//

import UIKit

enum CellType {
    case base
    case profile
    case exit
    case theme
}

final class ProfileCell: SettingsCell {
    
    static let ProfileCellId = String(describing: ProfileCell.self)
    private let subtitle = UILabel()
    private let leftViewButton = TTButton(with: .secondary)
    
    override func configure(title: String, type: CellType, image: UIImage) {
        super.configure(title: title, type: type, image: image)
        self.subtitle.text = UserDefaults.standard.group.components(separatedBy: ",").first
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
}
