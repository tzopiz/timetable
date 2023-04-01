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
    private let leftViewButton = TTButton(with: .primary)
    
    override func configure(title: String, type: CellType, image: UIImage) {
        self.title.text = title
        subtitle.text = UserDefaults.standard.group.components(separatedBy: ",").first
        leftViewButton.setImage(image, for: .normal)
        leftViewButton.setDimensions(height: 88, width: 88)
        leftViewButton.addButtonTarget(target: self, action: #selector(changePhotoProfile))
    }
    // TODO: chabge photo profile
    @objc func changePhotoProfile() {
        
    }
    override func setupViews() {
        super.setupViews()
        stackInfoView.addArrangedSubview(subtitle)
        setupView(leftViewButton)
    }
    override func constaintViews() {
        leftViewButton.anchor(left: leadingAnchor, paddingLeft: 16, centerY: centerYAnchor)
        title.setDimensions(height: 40)
        stackInfoView.anchor(left: leftViewButton.trailingAnchor, paddingLeft: 16,
                             right: trailingAnchor, paddingRight: -16,
                             centerY: centerYAnchor)
        leftViewButton.setDimensions(height: 88, width: 88)
    }

    override func configureAppearance() {
        super.configureAppearance()
       
        subtitle.font = App.Fonts.helveticaNeue(with: 15)
        subtitle.textColor = App.Colors.inactive
        subtitle.textAlignment = .left
        subtitle.numberOfLines = 0
        stackInfoView.axis = .vertical
        stackInfoView.spacing = 10
    }
}
