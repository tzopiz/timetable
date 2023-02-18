//
//  ProgressController.swift
//  WorkoutApp
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class ProgressController: TTBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ProgressController {
    override func setupViews() {
        super.setupViews()

    }

    override func constraintViews() {
        super.constraintViews()


    }

    override func configureAppearance() {
        super.configureAppearance()

        title = App.Strings.NavBar.progress
        navigationController?.tabBarItem.title = App.Strings.TabBar.title(for: .peoples)

        addNavBarButton(at: .left, with: App.Strings.Progress.navBarLeft)
        addNavBarButton(at: .right, with: App.Strings.Progress.navBarRight)
    }
}

