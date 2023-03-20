//
//  OverviewNavBar.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class OverviewNavBar: TTBaseView {
    
    private let weekView = WeekView()
    private let titleLabel = UILabel()
    private let allWorkoutsButton = TTButton(with: .secondary)
    private var separator = UIView()
}

extension OverviewNavBar {
    override func setupViews() {
        super.setupViews()
        setupView(separator)
        setupView(titleLabel)
        setupView(weekView)
        setupView(allWorkoutsButton)
    }

    override func constraintViews() {
        super.constraintViews()
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 7,
                          left: leadingAnchor, paddingLeft: 16,
                          right: trailingAnchor,
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
        self.backgroundColor = .clear
        
        addBottomBorder(separator: &separator, with: .black, height: 1)
        
        titleLabel.text = App.Strings.overview
        titleLabel.textColor = App.Colors.title
        titleLabel.font = App.Fonts.helveticaNeue(with: 22)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        allWorkoutsButton.isUserInteractionEnabled = false
        allWorkoutsButton.setTitle(dateFormatter.string(from: Date.now).uppercased())
        allWorkoutsButton.createCustomBackgroundView(with: 7, shadowOfSet: 0)
        allWorkoutsButton.backgroundColor = .clear
        createCustomBackgroundView(with: 0, shadowOfSet: 0)
    }
}
