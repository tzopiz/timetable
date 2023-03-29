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
    var completion: ((String) -> ())?
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
        
        titleLabel.setTitle(App.Strings.overview)
        titleLabel.addButtonTarget(target: self, action: #selector(toToday))
        
        allWorkoutsButton.backgroundColor = App.Colors.secondary

        let rightSwipe = UISwipeGestureRecognizer(target: self,action: #selector(rightSwipeWeek))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self,action: #selector(leftSwipeWeek))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)

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
        if weekView.shift > 0 {
            weekView.shift = 0
            animateRightSwipe() }
        if weekView.shift < 0 {
            weekView.shift = 0
            animateLeftSwipe()
        }
    }
    func updateButtonTitle(with title: String) {
        allWorkoutsButton.setTitle(title)
    }
    private func animateRightSwipe() {
        TTBaseView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            var weekViewFrame = self.weekView.frame
            weekViewFrame.origin.x -= weekViewFrame.size.width
            self.weekView.frame = weekViewFrame
            
            self.weekView.updateWeekView()
            
        }, completion:  {_ in })
        var weekViewFrame = self.weekView.frame
        weekViewFrame.origin.x += weekViewFrame.size.width
        self.weekView.frame = weekViewFrame
        completion?(getFirstDay())
    }
    private func animateLeftSwipe() {
        TTBaseView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            var weekViewFrame = self.weekView.frame
            weekViewFrame.origin.x += weekViewFrame.size.width
            self.weekView.frame = weekViewFrame
            
            self.weekView.updateWeekView()
            
        }, completion:  {_ in })
        var weekViewFrame = self.weekView.frame
        weekViewFrame.origin.x -= weekViewFrame.size.width
        self.weekView.frame = weekViewFrame
        completion?(getFirstDay())
    }
    func getFirstDay() -> String {
        "\(self.weekView.firstDay!)".components(separatedBy: " ").first ?? "\(Date())"
    }
}
