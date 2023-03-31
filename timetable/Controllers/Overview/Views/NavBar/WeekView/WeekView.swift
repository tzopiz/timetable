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
            switch touch.view {
            case self.weekdayViews[0]:
                animateTouch(0)
                completion?(0)
            case self.weekdayViews[1]:
                animateTouch(1)
                completion?(1)
            case self.weekdayViews[2]:
                animateTouch(2)
                completion?(2)
            case self.weekdayViews[3]:
                animateTouch(3)
                completion?(3)
            case self.weekdayViews[4]:
                animateTouch(4)
                completion?(4)
            case self.weekdayViews[5]:
                animateTouch(5)
                completion?(5)
            case self.weekdayViews[6]:
                animateTouch(6)
            default: break
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
