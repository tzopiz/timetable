//
//  OverviewNavBar.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class OverviewNavBar: TTBaseView {
    
    private let weekView = WeekView()

    private let titleLabel: UILabel = {
        let lable = UILabel()
        lable.text = App.Strings.NavBar.overview
        lable.textColor = App.Colors.titleGray
        lable.font = App.Fonts.helveticaNeue(with: 22)
        return lable
    }()
    
    private let allWorkoutsButton: TTButton = {
        let button = TTButton(with: .secondary)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        button.isUserInteractionEnabled = false
        button.setTitle(dateFormatter.string(from: Date.now).uppercased())
        
        return button
    }()
}

extension OverviewNavBar {
    override func setupViews() {
        super.setupViews()

        setupView(titleLabel)
        setupView(weekView)
        setupView(allWorkoutsButton)
    }

    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            
            allWorkoutsButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
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
        addBottomBorder(with: App.Colors.separator, height: 1)
    }
}
