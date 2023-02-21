//
//  SectionHeaderView.swift
//  timtable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    
    static let id = "SectionHeaderView"

    private let title: UILabel = {
        let lable = UILabel()
        lable.font = App.Fonts.menloRegular(with: 14)
        lable.textColor = App.Colors.inactive
        lable.textAlignment = .center
        return lable
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        constaintViews()
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)

        setupViews()
        constaintViews()
        configureAppearance()
    }

    func configure(with title: String) {
        self.title.text = title.uppercased()
    }
}

private extension SectionHeaderView {
    
    func setupViews() {
        setupView(title)
    }

    func constaintViews() {
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configureAppearance() {}
}

