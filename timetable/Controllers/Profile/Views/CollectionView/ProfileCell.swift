//
//  ProfileCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//

import UIKit

final class ProfileCell: BaseCell {
    
    static let ProfileCellId = String(describing: ProfileCell.self)
    private let subtitle = UILabel()
    private let leftView = UIImageView()
    var completion: (() -> (UIImage))?
    func configure(title: String, type: CellType = .base, image: UIImage? = nil) {
        self.title.text = title
        subtitle.text = UserDefaults.standard.group.components(separatedBy: ",").first
        let profileImage = CoreDataMamanager.shared.fetchImageProfile()
        leftView.image = profileImage
        leftView.addTapGesture(tapNumber: 1, target: self, action: #selector(changePhotoProfile))
    }
    @IBAction func changePhotoProfile() {
        let newImage = CoreDataMamanager.shared.fetchImageProfile()
        self.leftView.image = newImage
    }
    override func setupViews() {
        super.setupViews()
        stackInfoView.addArrangedSubview(subtitle)
        setupView(leftView)
    }
    override func constaintViews() {
        leftView.anchor(left: leadingAnchor, paddingLeft: 16, centerY: centerYAnchor)
        title.setDimensions(height: 40)
        stackInfoView.anchor(left: leftView.trailingAnchor, paddingLeft: 16,
                             right: trailingAnchor, paddingRight: -16,
                             centerY: centerYAnchor)
        leftView.setDimensions(height: 88, width: 88)
    }

    override func configureAppearance() {
        super.configureAppearance()
       
        subtitle.font = App.Fonts.helveticaNeue(with: 15)
        subtitle.textColor = App.Colors.inactive
        subtitle.textAlignment = .left
        subtitle.numberOfLines = 0
        stackInfoView.axis = .vertical
        stackInfoView.spacing = 10
        
        leftView.layer.cornerRadius = 44
        leftView.layer.borderWidth = 1
        leftView.layer.borderColor = App.Colors.separator.cgColor
        leftView.clipsToBounds = true
    }
}
