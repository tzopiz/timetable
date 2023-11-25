//
//  CacheInfoCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 14.08.2023.
//

import UIKit
import SnapKit

final class CacheInfoCell: BaseCell {
    override class var reuseIdentifier: String { return String(describing: CacheInfoCell.self) }
    private let cacheSizeLabel = TTLabel(textColor: R.color.inactive(), fontSize: 15, textAlignment: .right)
    func configure(title: String, cacheSize: String) {
        super.configure(title: title)
        cacheSizeLabel.text = cacheSize
    }
}
extension CacheInfoCell {
    override func setupViews() {
        super.setupViews()
        addSubview(cacheSizeLabel)
    }
    override func layoutViews() {
        super.layoutViews()
        cacheSizeLabel.snp.makeConstraints { $0.top.bottom.trailing.equalToSuperview().inset(16) }
    }
}
