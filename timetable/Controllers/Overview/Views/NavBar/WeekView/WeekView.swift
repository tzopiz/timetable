//
//  WeekView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class WeekView: TTBaseView {
    private let stackView = UIStackView()
    private var weekdayViews: [WeekdayView] = []
    var shift = 0
    var firstDay: Date?
}
extension WeekView {
    override func setupViews() {
        super.setupViews()
        setupView(stackView)
    }
    override func constraintViews() {
        super.constraintViews()
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor)
    }
    override func configureAppearance() {
        super.configureAppearance()
        self.backgroundColor = App.Colors.BlackWhite
        
        stackView.spacing = 7
        stackView.distribution = .fillEqually

        var weekdays = Date.calendar.shortStandaloneWeekdaySymbols

        if Date.calendar.firstWeekday == 2 {
            let sun = weekdays.remove(at: 0)
            weekdays.append(sun)
        }

        weekdays.enumerated().forEach { index, name in
            weekdayViews.append(WeekdayView())
            weekdayViews[index].configure(with: index, and: name, shift: shift)
            stackView.addArrangedSubview(weekdayViews[index])
        }
    }
    func updateWeekView() {
        var weekdays = Date.calendar.shortStandaloneWeekdaySymbols
        if Date.calendar.firstWeekday == 2 {
            let sun = weekdays.remove(at: 0)
            weekdays.append(sun)
        }
        weekdays.enumerated().forEach { index, name in
            let view = WeekdayView()
            weekdayViews.append(view)
            weekdayViews[index].configure(with: index, and: name, shift: shift)
        }
        firstDay = WeekdayView.getFirstDay(with: shift)
    }
}
