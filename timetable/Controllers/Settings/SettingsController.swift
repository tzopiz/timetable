//
//  SettingsController.swift
//  WorkoutApp
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class SettingsController: TTBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingsController {
    override func setupViews() {
        super.setupViews()
      

    }

    override func constraintViews() {
        super.constraintViews()

    }

    override func configureAppearance() {
        super.configureAppearance()
        title = App.Strings.NavBar.settings
        navigationController?.tabBarItem.title = App.Strings.TabBar.title(for: .profile)
    }
}
