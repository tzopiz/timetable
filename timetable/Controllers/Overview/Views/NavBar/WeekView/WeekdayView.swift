//
//  WeekdayView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

extension WeekView {
    final class WeekdayView: TTBaseView {

        private let nameLabel = UILabel()
        private let dateLabel = UILabel()

        private let stackView = UIStackView()

        func configure(with index: Int, and name: String) {
            let startOfWeek = Date().startOfWeek
            let currenrDay = startOfWeek.agoForward(to: index)
            let day = Date.calendar.component(.day, from: currenrDay)

            let isToday = currenrDay.stripTime(.toDays) == Date().stripTime(.toDays)

            backgroundColor = isToday ? App.Colors.active : App.Colors.background

            nameLabel.text = name.uppercased()
            nameLabel.textColor = isToday ? .white : App.Colors.inactive

            dateLabel.text = "\(day)"
            dateLabel.textColor = isToday ? .white : App.Colors.inactive
        }
    }
}

extension WeekView.WeekdayView {
    override func setupViews() {
        super.setupViews()

        setupView(stackView)

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dateLabel)
    }

    override func constraintViews() {
        super.constraintViews()

        stackView.anchor(centerY: centerYAnchor, centerX: centerXAnchor)
    }

    override func configureAppearance() {
        super.configureAppearance()

        layer.cornerRadius = 5
        layer.masksToBounds = true
        nameLabel.font = App.Fonts.helveticaNeue(with: 9)
        nameLabel.textAlignment = .center
        
        dateLabel.font = App.Fonts.helveticaNeue(with: 15)
        dateLabel.textAlignment = .center
        
        stackView.spacing = 3
        stackView.axis = .vertical
    }
}
