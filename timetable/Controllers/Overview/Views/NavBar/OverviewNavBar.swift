//
//  OverviewNavBar.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class OverviewNavBar: TTBaseView {
    private let weekView = WeekView()
    private let scheduleNavigatorView = ScheduleNavigatorView()
    private let monthButton = TTButton(with: .secondary)
    private var separator = UIView()
    var swipeCompletion: ((WeekView.SwipeDirections) -> Void)?
    var scrollCompletion: ((Int) -> Void)?
}

extension OverviewNavBar {
    override func setupViews() {
        addSubview(scheduleNavigatorView)
        addSubview(weekView)
        addSubview(separator)
        addSubview(monthButton)
    }
    override func layoutViews() {
        scheduleNavigatorView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 7,
                                     left: leadingAnchor, paddingLeft: 16,
                                     centerY: monthButton.centerYAnchor)
        
        monthButton.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 7,
                           right: trailingAnchor, paddingRight: -16)
        monthButton.setDimensions(height: 28)
        
        weekView.anchor(top: scheduleNavigatorView.bottomAnchor, paddingTop: 16,
                        bottom: bottomAnchor, paddingBottom: -16,
                        left: leadingAnchor, paddingLeft: 16,
                        right: trailingAnchor, paddingRight: -16)
        weekView.setDimensions(height: 47)
        
        separator.anchor(bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor)
        separator.setDimensions(height: 1)
    }
    override func configureViews() {
        self.backgroundColor = R.color.blackWhite()
        
        scheduleNavigatorView.swipeCompletion =  { [weak self] direction in
            guard let self = self else { return }
            self.swipeCompletion?(direction)
        }
        scheduleNavigatorView.titleAction = { [weak self] in
            guard let self = self else { return }
            self.toToday()
        }
        
        weekView.scrollCompletion = { [weak self] index in
            guard let self = self else { return }
            self.scrollCompletion?(index)
        }
        
        monthButton.backgroundColor = R.color.secondary()
        monthButton.isUserInteractionEnabled = false // TODO: show datapicker
        
        separator.backgroundColor = R.color.secondary()
    }
    
    func swipeWeekView(to direct: WeekView.SwipeDirections) {
        switch direct {
        case .back:
            weekView.shift -= 7
            animateSwipeWeekView(to: .back)
        case .forward:
            weekView.shift += 7
            animateSwipeWeekView(to: .forward)
        }
        scrollCompletion?(0)
    }
    private func toToday() {
        if weekView.shift > 0 {
            weekView.shift = 7
            swipeCompletion?(.back)
        } else if weekView.shift < 0 {
            weekView.shift = -7
            swipeCompletion?(.forward)
        } else { scrollCompletion?(weekView.todayIndex) }
    }
    private func animateSwipeWeekView(to direct: WeekView.SwipeDirections) {
        switch direct {
        case .back:
            UIView.animate(withDuration: 0.3, animations: {
                self.weekView.transform = CGAffineTransform(translationX: self.weekView.frame.width, y: 0)
                self.weekView.alpha = 0.5
            }) { _ in
                self.weekView.alpha = 0
                self.weekView.updateWeekView()
                self.weekView.transform = CGAffineTransform(translationX: -self.weekView.frame.width, y: 0)
                UIView.animate(withDuration: 0.4, animations: {
                    self.weekView.transform = .identity
                    self.weekView.alpha = 1.0
                })
            }
        case .forward:
            UIView.animate(withDuration: 0.3, animations: {
                self.weekView.transform = CGAffineTransform(translationX: -self.weekView.frame.width, y: 0)
                self.weekView.alpha = 0.5
            }) { _ in
                self.weekView.alpha = 0
                self.weekView.updateWeekView()
                self.weekView.transform = CGAffineTransform(translationX: self.weekView.frame.width, y: 0)
                UIView.animate(withDuration: 0.4, animations: {
                    self.weekView.transform = .identity
                    self.weekView.alpha = 1.0
                })
            }
        }
    }
    
    func getFirstDay() -> String {
        guard let firstDay = self.weekView.firstDay else { return "" }
        return "\(firstDay)".components(separatedBy: " ").first ?? "\(Date())"
    }
    func updateButtonTitle(with title: String) { monthButton.setTitle(title) }
}
