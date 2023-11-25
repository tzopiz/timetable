//
//  ImageViewCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 13.08.2023.
//

import UIKit
import SnapKit

final class ImageViewCell: BaseCell {
    override class var reuseIdentifier: String { return String(describing: ImageViewCell.self) }
    private let imageView = UIImageView(image: R.image.nullBackground())
}
 
extension ImageViewCell {
    override func setupViews() {
        contentView.addSubview(imageView)
    }
    override func layoutViews() {
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    override func configureViews() {
        self.backgroundColor = R.color.blackWhite()
        self.layer.cornerRadius = 16
    }
}
