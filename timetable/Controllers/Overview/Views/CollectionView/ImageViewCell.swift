//
//  ImageViewCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 13.08.2023.
//

import UIKit

class ImageViewCell: BaseCell {
    override class var reuseIdentifier: String { return String(describing: ImageViewCell.self) }
    private let imageView = UIImageView(image: App.Images.null_background)
}
 
extension ImageViewCell {
    override func setupViews() {
        contentView.setupView(imageView)
    }
    override func constraintViews() {
        imageView.anchor(top: contentView.topAnchor, paddingTop: 8,
                         bottom: contentView.bottomAnchor, paddingBottom: -8,
                         left: contentView.leadingAnchor, paddingLeft: 16,
                         right: contentView.trailingAnchor, paddingRight: -16)
    }
    override func configureAppearance() {
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 16
    }
}
