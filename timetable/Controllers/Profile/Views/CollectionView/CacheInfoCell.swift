//
//  CacheInfoCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 14.08.2023.
//

import UIKit

final class CacheInfoCell: BaseCell {
    override class var reuseIdentifier: String { return String(describing: CacheInfoCell.self) }
    private let cacheSizeLabel = TTLabel(textColor: App.Colors.inactive, fontSize: 15, textAlignment: .right)
    func configure(title: String, cacheSize: String) {
        super.configure(title: title)
        cacheSizeLabel.text = cacheSize
    }
}
extension CacheInfoCell {
    override func setupViews() {
        super.setupViews()
        setupView(cacheSizeLabel)
    }
    override func constraintViews() {
        super.constraintViews()
        cacheSizeLabel.anchor(top: topAnchor, paddingTop: 16,
                              bottom: bottomAnchor, paddingBottom: -16,
                              right: trailingAnchor, paddingRight: -16)
    }
}
