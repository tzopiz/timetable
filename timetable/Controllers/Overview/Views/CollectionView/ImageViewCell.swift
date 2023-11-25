//
//  ImageViewCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 13.08.2023.
//

import UIKit

final class ImageViewCell: BaseCell {
    override class var reuseIdentifier: String { return String(describing: ImageViewCell.self) }
    private let imageView = UIImageView(image: R.image.nullBackground())
}
 
extension ImageViewCell {
    override func setupViews() {
        contentView.addSubview(imageView)
    }
    override func layoutViews() {
        imageView.anchor(top: contentView.topAnchor, paddingTop: 8,
                         bottom: contentView.bottomAnchor, paddingBottom: -8,
                         left: contentView.leadingAnchor, paddingLeft: 16,
                         right: contentView.trailingAnchor, paddingRight: -16)
    }
    override func configureViews() {
        self.backgroundColor = R.color.blackWhite()
        self.layer.cornerRadius = 16
    }
}
