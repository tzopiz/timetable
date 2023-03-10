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

        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 7),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: allWorkoutsButton.centerYAnchor),
            
            allWorkoutsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 7),
            allWorkoutsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            allWorkoutsButton.heightAnchor.constraint(equalToConstant: 28),
            
            weekView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            weekView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            weekView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            weekView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            weekView.heightAnchor.constraint(equalToConstant: 47)
            
        ])
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addBottomBorder(separator: &separator,with: App.Colors.separator, height: 1)
        
        titleLabel.text = App.Strings.NavBar.overview
        titleLabel.textColor = App.Colors.titleGray
        titleLabel.font = App.Fonts.helveticaNeue(with: 22)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        allWorkoutsButton.isUserInteractionEnabled = false
        allWorkoutsButton.setTitle(dateFormatter.string(from: Date.now).uppercased())

    }
}
