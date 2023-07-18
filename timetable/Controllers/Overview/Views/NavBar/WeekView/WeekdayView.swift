//
//  WeekdayView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

extension WeekView {
    final class WeekdayView: TTBaseView {

        private let nameLabel = TTLabel(fontSize: 9, textAlignment: .center)
        private let dateLabel = TTLabel(textAlignment: .center)
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.spacing = 3
            stackView.axis = .vertical
            stackView.isUserInteractionEnabled = false
            return stackView
        }()

        func configure(with index: Int, and name: String, shift: Int) {
            let startOfWeek = Date().startOfWeek
            let currenrDay = startOfWeek.agoForward(to: index - shift)
            let day = Date.calendar.component(.day, from: currenrDay)
            let isToday = currenrDay.stripTime(.toDays) == Date().stripTime(.toDays)

            backgroundColor = isToday ? App.Colors.active : App.Colors.background

            nameLabel.text = name.uppercased()
            nameLabel.textColor = isToday ? .white : App.Colors.text_2

            dateLabel.text = "\(day)"
            dateLabel.textColor = isToday ? .white : App.Colors.text_2
        }
        static func getFirstDay(with index: Int) -> Date {
            let startOfWeek = Date().startOfWeek
            let currenrDay = startOfWeek.agoForward(to: 1 - index)
            return currenrDay
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
    }
}
