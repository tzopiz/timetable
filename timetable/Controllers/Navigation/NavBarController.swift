//
//  NavBarController.swift
//  WorkoutApp
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class NavBarController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
    }

    private func configureAppearance() {
        view.backgroundColor = .white
        navigationBar.isTranslucent = false
        navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: App.Colors.titleGray,
            .font: App.Fonts.menloRegular(with: 17)
        ]

        navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
    }
}
