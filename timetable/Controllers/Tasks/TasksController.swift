//
//  TasksController.swift
//  timtable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class TasksController: TTBaseController {

//    override func navBarLeftButtonHandler() {
//        print("list new tasks")
//    }
//
//    override func navBarRightButtonHandler() {
//        print("list old tasks")
//    }
}

extension TasksController {
    override func setupViews() {
        super.setupViews()

    }

    override func constraintViews() {
        super.constraintViews()
    }

    override func configureAppearance() {
        super.configureAppearance()

        title = App.Strings.NavBar.session
        navigationController?.tabBarItem.title = App.Strings.TabBar.title(for: .tasks)

        addNavBarButton(at: .left, with: App.Strings.Session.navBarStart)
        addNavBarButton(at: .right, with: App.Strings.Session.navBarFinish)
        
    }
}
