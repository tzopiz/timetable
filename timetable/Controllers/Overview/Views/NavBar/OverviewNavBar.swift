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
    private let allWorkoutsButton = TTButton(with: .secondary)
    private var separator = UIView()
    var completionUpdate: ((Int?) -> ())?
    var completionActionTo: ((WeekView.Directions) -> Void)?
}

extension OverviewNavBar {
    override func setupViews() {
        super.setupViews()
        setupView(scheduleNavigatorView)
        setupView(weekView)
        setupView(separator)
        setupView(allWorkoutsButton)
    }
    override func constraintViews() {
        super.constraintViews()
        scheduleNavigatorView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 7,
                                     left: leadingAnchor, paddingLeft: 16,
                                     centerY: allWorkoutsButton.centerYAnchor)
        
        allWorkoutsButton.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 7,
                                 right: trailingAnchor, paddingRight: -16)
        allWorkoutsButton.setDimensions(height: 28)
        
        weekView.anchor(top: scheduleNavigatorView.bottomAnchor, paddingTop: 16,
                        bottom: bottomAnchor, paddingBottom: -16,
                        left: leadingAnchor, paddingLeft: 16,
                        right: trailingAnchor, paddingRight: -16)
        weekView.setDimensions(height: 47)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = App.Colors.BlackWhite
        weekView.updateWeekView()
        addBottomBorder(separator: &separator, with: App.Colors.separator, height: 1)
        
        scheduleNavigatorView.titleAction = { [weak self] in
            guard let self = self else { return }
            self.toToday()
        }
        scheduleNavigatorView.completionActionTo = completionActionTo
        allWorkoutsButton.backgroundColor = App.Colors.secondary
        weekView.completion = self.completionUpdate
    }
    @IBAction func rightSwipeWeek() {
        weekView.shift += 7
        animateLeftSwipe()
        completionUpdate?(nil)
    }
    @IBAction func leftSwipeWeek() {
        weekView.shift -= 7
        animateRightSwipe()
        completionUpdate?(nil)
    }
    @IBAction func toToday() {
        if weekView.shift > 0 {
            weekView.shift = 0
            animateRightSwipe()
        }
        if weekView.shift < 0 {
            weekView.shift = 0
            animateLeftSwipe()
        }
        completionUpdate?(weekView.todayIndex)
    }
    private func animateRightSwipe() {
        UIView.animate(withDuration: 0.3, animations: {
            self.weekView.transform = CGAffineTransform(translationX: -self.weekView.frame.width, y: 0)
            self.weekView.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.001, animations: {
                self.weekView.transform = CGAffineTransform(translationX: self.weekView.frame.width, y: 0)
                self.weekView.alpha = 0
            }) { _ in
                UIView.animate(withDuration: 0.4, animations: {
                    self.weekView.transform = .identity
                    self.weekView.alpha = 1.0
                })
            }
        }
        self.weekView.updateWeekView()
    }
    
    private func animateLeftSwipe() {
        UIView.animate(withDuration: 0.3, animations: {
            self.weekView.transform = CGAffineTransform(translationX: self.weekView.frame.width, y: 0)
            self.weekView.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.001, animations: {
                self.weekView.transform = CGAffineTransform(translationX: -self.weekView.frame.width, y: 0)
                self.weekView.alpha = 0
            }) { _ in
                UIView.animate(withDuration: 0.4, animations: {
                    self.weekView.transform = .identity
                    self.weekView.alpha = 1.0
                })
            }
        }
        self.weekView.updateWeekView()
    }
    
    func getFirstDay() -> String {
        guard let firstDay = self.weekView.firstDay else { return "" }
        return "\(firstDay)".components(separatedBy: " ").first ?? "\(Date())"
    }
    func updateButtonTitle(with title: String) { allWorkoutsButton.setTitle(title) }
}
