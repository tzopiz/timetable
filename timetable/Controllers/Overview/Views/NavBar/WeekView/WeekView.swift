//
//  WeekView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class WeekView: TTBaseView {
    enum SwipeDirections {
        case back
        case forward
    }
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        return stackView
    }()
    private var weekdayViews: [WeekdayView] = []
    
    var shift = 0
    var firstDay: Date?
    var todayIndex: Int = 0
    var scrollCompletion: ((Int) -> Void)?
}
extension WeekView {
    override func setupViews() {
        setupView(stackView)
    }
    override func constraintViews() {
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        self.backgroundColor = .clear
        
        let russianLocale = Locale(identifier: "ru_RU")
        var weekdays = russianLocale.calendar.shortWeekdaySymbols
        if Date.calendar.firstWeekday == 2 {
            let sun = weekdays.remove(at: 0)
            weekdays.append(sun)
        }
        
        weekdays.enumerated().forEach { index, name in
            let day = WeekdayView(index: index)
            day.scrollCompletion = { [weak self] index in
                guard let self = self else { return }
                scrollCompletion?(index)
            }
            weekdayViews.append(day)
            weekdayViews[index].configure(with: index, name: name, shift: shift)
            stackView.addArrangedSubview(weekdayViews[index])
        }
        firstDay = WeekdayView.getFirstDay(with: shift)
        updateTodayIndex()
    }
    func updateWeekView() {
        var weekdays = Date.calendar.shortStandaloneWeekdaySymbols
        if Date.calendar.firstWeekday == 2 {
            let sun = weekdays.remove(at: 0)
            weekdays.append(sun)
        }
        weekdays.enumerated().forEach { index, name in
            let day = WeekdayView(index: index)
            day.scrollCompletion = { [weak self] index in
                guard let self = self else { return }
                scrollCompletion?(index)
            }
            weekdayViews.append(day)
            weekdayViews[index].configure(with: index, name: name, shift: shift)
        }
        firstDay = WeekdayView.getFirstDay(with: shift)
        updateTodayIndex()
    }
}

extension WeekView {
    private func updateTodayIndex() {
        for i in 0..<weekdayViews.count {
            let startOfWeek = Date().startOfWeek
            let currenrDay = startOfWeek.agoForward(to: i + shift)
            let isToday = currenrDay.stripTime(.toDays) == Date().stripTime(.toDays)
            if isToday { self.todayIndex = i }
        }
    }
}
