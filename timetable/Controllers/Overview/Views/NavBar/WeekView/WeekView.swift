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
    var todayIndex: Int = 0
    var completion: ((Int) -> ())?
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
            let view = WeekdayView()
            weekdayViews.append(view)
            weekdayViews[index].configure(with: index, and: name, shift: shift)
        }
        firstDay = WeekdayView.getFirstDay(with: shift)
        updateTodayIndex()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            for i in 0..<weekdayViews.count where touch.view == weekdayViews[i] {
                animateTouch(i)
                completion?(i)
            }
        }
    }
    
    func updateTodayIndex() {
        for i in 0..<weekdayViews.count {
            let startOfWeek = Date().startOfWeek
            let currenrDay = startOfWeek.agoForward(to: i - shift)
            let isToday = currenrDay.stripTime(.toDays) == Date().stripTime(.toDays)
            if isToday {
                self.todayIndex = i
            }
        }
    }
    private func animateTouch(_ i: Int) {
        let view = weekdayViews[i]
        let startOfWeek = Date().startOfWeek
        let currenrDay = startOfWeek.agoForward(to: i - shift)
        let isToday = currenrDay.stripTime(.toDays) == Date().stripTime(.toDays)
        
        let backgroundColor = isToday ? App.Colors.active : App.Colors.background
        let animateColor = isToday ? App.Colors.active.withAlphaComponent(0.4) : App.Colors.secondary
        
        TTBaseView.animate(withDuration: 0.5, delay: 0, options: .allowAnimatedContent, animations: {
            view.backgroundColor = animateColor
        }, completion:  {_ in })
        TTBaseView.animate(withDuration: 0.5, delay: 0, options: .allowAnimatedContent, animations: {
            view.backgroundColor = backgroundColor
        }, completion:  {_ in })
    }
    
}
