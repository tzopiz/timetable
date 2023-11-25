//
//  ProfileCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//

import UIKit
import SnapKit

final class ProfileCell: BaseCell {
    
    override class var reuseIdentifier: String { return String(describing: ProfileCell.self) }

    private let subtitle = TTLabel(textColor: R.color.subtitle())
    private let leftView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 44
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = R.color.separator()?.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    var completion: (() -> (UIImage))?
    
    func configure(title: String, type: CellType = .base, image: UIImage? = nil) {
        super.configure(title: title)
        subtitle.text = UserDefaults.standard.group
        let profileImage = R.image.person_crop_circle_fill()
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
        addSubview(leftView)
    }
    override func layoutViews() {
        leftView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(88)
        }
        title.snp.makeConstraints { $0.height.equalTo(40) }
        stackInfoView.snp.makeConstraints { make in
            make.leading.equalTo(leftView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    override func configureViews() {
        super.configureViews()
        stackInfoView.axis = .vertical
        stackInfoView.spacing = 10
    }
}
