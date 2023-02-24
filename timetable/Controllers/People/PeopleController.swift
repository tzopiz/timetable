//
//  PeopleController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class PeopleController: TTBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PeopleController {
    override func setupViews() {
        super.setupViews()

    }

    override func constraintViews() {
        super.constraintViews()


    }

    override func configureAppearance() {
        super.configureAppearance()

        title = App.Strings.NavBar.progress
        navigationController?.tabBarItem.title = App.Strings.TabBar.title(for: .people)

        addNavBarButton(at: .left, with: App.Strings.Progress.navBarLeft)
        addNavBarButton(at: .right, with: App.Strings.Progress.navBarRight)
    }
}

