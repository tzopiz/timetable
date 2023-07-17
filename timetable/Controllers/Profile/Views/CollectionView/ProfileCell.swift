//
//  ProfileCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//

import UIKit

final class ProfileCell: BaseCell {
    
    static let ProfileCellId = String(describing: ProfileCell.self)
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.helveticaNeue(with: 15)
        label.textColor = App.Colors.text_2
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private let leftView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 44
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = App.Colors.separator.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    var completion: (() -> (UIImage))?
    
    func configure(title: String, type: CellType = .base, image: UIImage? = nil) {
        super.configure(title: title)
        subtitle.text = UserDefaults.standard.group
        let profileImage = CoreDataMamanager.shared.fetchImageProfile()
        leftView.image = profileImage
        leftView.addTapGesture(tapNumber: 1, target: self, action: #selector(changePhotoProfile))
    }
    @IBAction func changePhotoProfile() {
        let newImage = CoreDataMamanager.shared.fetchImageProfile()
        self.leftView.image = newImage
    }
}

extension ProfileCell {
    override func setupViews() {
        super.setupViews()
        stackInfoView.addArrangedSubview(subtitle)
        setupView(leftView)
    }
    override func constraintViews() {
        leftView.anchor(left: leadingAnchor, paddingLeft: 16, centerY: centerYAnchor)
        title.setDimensions(height: 40)
        stackInfoView.anchor(left: leftView.trailingAnchor, paddingLeft: 16,
                             right: trailingAnchor, paddingRight: -16,
                             centerY: centerYAnchor)
        leftView.setDimensions(height: 88, width: 88)
    }
    override func configureAppearance() {
        super.configureAppearance()
        stackInfoView.axis = .vertical
        stackInfoView.spacing = 10
    }
}
