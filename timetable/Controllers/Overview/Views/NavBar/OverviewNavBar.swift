//
//  OverviewNavBar.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class OverviewNavBar: TTBaseView {
    private let weekView = WeekView()
    private let titleLabel = TTButton(with: .primary)
    private let allWorkoutsButton = TTButton(with: .secondary)
    private var separator = UIView()
}

extension OverviewNavBar {
    override func setupViews() {
        super.setupViews()
        setupView(titleLabel)
        setupView(weekView)
        setupView(separator)
        setupView(allWorkoutsButton)
    }

    override func constraintViews() {
        super.constraintViews()
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 7,
                          left: leadingAnchor, paddingLeft: 16,
                          centerY: allWorkoutsButton.centerYAnchor)

        allWorkoutsButton.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 7,
                                 right: trailingAnchor, paddingRight: -16)
        allWorkoutsButton.setDimensions(height: 28)

        weekView.anchor(top: titleLabel.bottomAnchor, paddingTop: 16,
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
        updateButtonTitle(day: weekView.firstDay)
        
        titleLabel.setTitle(App.Strings.overview)
        titleLabel.addButtonTarget(target: self, action: #selector(toToday))

        let rightSwipe = UISwipeGestureRecognizer(target: self,action: #selector(rightSwipeWeek))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self,action: #selector(leftSwipeWeek))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(leftSwipeWeek))
        addGestureRecognizer(tap)
    }
    @objc func rightSwipeWeek() {
        weekView.shift += 7
        animateLeftSwipe()
    }
    @objc func leftSwipeWeek() {
        weekView.shift -= 7
        animateRightSwipe()
    }
    @objc func toToday() {
        weekView.shift = 0
        if weekView.shift > 0 { animateRightSwipe() }
        if weekView.shift < 0 { animateLeftSwipe() }
    }
    func updateButtonTitle(day: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, YYYY"
        allWorkoutsButton.setTitle(dateFormatter.string(from: day ?? Date.now).uppercased())
    }
    func animateRightSwipe() {
        TTBaseView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            var weekViewFrame = self.weekView.frame
            weekViewFrame.origin.x -= weekViewFrame.size.width
            self.weekView.frame = weekViewFrame
            
            self.weekView.updateWeekView()
            self.updateButtonTitle(day: self.weekView.firstDay)
            
        }, completion:  {_ in })
        var weekViewFrame = self.weekView.frame
        weekViewFrame.origin.x += weekViewFrame.size.width
        self.weekView.frame = weekViewFrame
    }
    func animateLeftSwipe() {
        TTBaseView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            var weekViewFrame = self.weekView.frame
            weekViewFrame.origin.x += weekViewFrame.size.width
            self.weekView.frame = weekViewFrame
            
            self.weekView.updateWeekView()
            self.updateButtonTitle(day: self.weekView.firstDay)
            
        }, completion:  {_ in })
        var weekViewFrame = self.weekView.frame
        weekViewFrame.origin.x -= weekViewFrame.size.width
        self.weekView.frame = weekViewFrame
    }
}
