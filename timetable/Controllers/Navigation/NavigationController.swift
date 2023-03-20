//
//  NavigationController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
// timetable

import UIKit

final class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
    }

    private func configureAppearance() {
        view.backgroundColor = .clear
        navigationBar.isTranslucent = false
        navigationBar.createCustomBackgroundView(with: 0, shadowOfSet: 0)
        navigationBar.backgroundColor = .clear
        navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: App.Colors.title,
            .font: App.Fonts.helveticaNeue(with: 17)
        ]
    }
}
