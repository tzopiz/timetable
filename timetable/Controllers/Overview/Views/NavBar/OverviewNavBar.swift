//
//  OverviewNavBar.swift
//  timtable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class OverviewNavBar: TTBaseView {

    private let titleLabel: UILabel = {
        let lable = UILabel()
        lable.text = App.Strings.NavBar.overview
        lable.textColor = App.Colors.titleGray
        lable.font = App.Fonts.menloRegular(with: 22)
        return lable
    }()
    private let weekView = WeekView()
    
}

extension OverviewNavBar {
    override func setupViews() {
        super.setupViews()

        setupView(titleLabel)
        setupView(weekView)
    }

    override func constaintViews() {
        super.constaintViews()

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            weekView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            weekView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            weekView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            weekView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            weekView.heightAnchor.constraint(equalToConstant: 47)
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
