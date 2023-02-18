//
//  OverviewNavBar.swift
//  WorkoutApp
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class OverviewNavBar: TTBaseView {

    private let titleLabel: UILabel = {
        let lable = UILabel()
        lable.text = App.Strings.NavBar.overview
        lable.textColor = App.Colors.titleGray
        lable.font = App.Fonts.menloRegular(with: 22)
        return lable
    }()

    private let allWorkoutsButton: TTButton = {
        let button = TTButton(with: .secondary)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        button.setTitle(dateFormatter.string(from: Date()))
        return button
    }()

    private let weekView = WeekView()

    override func layoutSubviews() {
        super.layoutSubviews()

        addBottomBorder(with: App.Colors.separator, height: 1)
    }

    func addAllWorkoutsAction(_ action: Selector, with target: Any?) {
        allWorkoutsButton.addTarget(target, action: action, for: .touchUpInside)
    }

    func addAdditingAction(_ action: Selector, with target: Any?) {
    }
}

extension OverviewNavBar {
    override func setupViews() {
        super.setupViews()

        setupView(titleLabel)
        setupView(allWorkoutsButton)
        setupView(weekView)
    }

    override func constaintViews() {
        super.constaintViews()

        NSLayoutConstraint.activate([
            allWorkoutsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            allWorkoutsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            allWorkoutsButton.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.centerYAnchor.constraint(equalTo: allWorkoutsButton.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: allWorkoutsButton.leadingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            weekView.topAnchor.constraint(equalTo: allWorkoutsButton.bottomAnchor, constant: 15),
            weekView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            weekView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            weekView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            weekView.heightAnchor.constraint(equalToConstant: 47)
        ])
    }
}
