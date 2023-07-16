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
        view.backgroundColor = App.Colors.BlackWhite
        navigationBar.isTranslucent = false
        navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: App.Colors.text,
            .font: App.Fonts.helveticaNeue(with: 17)
        ]
    }
}
