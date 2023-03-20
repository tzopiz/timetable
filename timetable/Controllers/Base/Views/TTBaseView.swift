//
//  TTBaseView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

class TTBaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        constraintViews()
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        constraintViews()
        configureAppearance()
    }
}

@objc extension TTBaseView {
    func setupViews() {}
    func constraintViews() {}
    func configureAppearance() { backgroundColor = .clear }
}
