//
//  SettingsController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class ProfileController: TTBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ProfileController {
    override func setupViews() {
        super.setupViews()
      

    }

    override func constraintViews() {
        super.constraintViews()

    }

    override func configureAppearance() {
        super.configureAppearance()
        title = App.Strings.NavBar.profile
        navigationController?.tabBarItem.title = App.Strings.TabBar.title(for: .profile)
    }
}
