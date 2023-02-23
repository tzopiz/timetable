//
//  TasksController.swift
//  timtable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

class TasksController: TTBaseController {
    
    private let id = "Cell"
    private let navBar = TasksNavBar()
}

extension TasksController {
    override func setupViews() {
        super.setupViews()
        
        view.setupView(navBar)
        
        navBar.currentTasksAction(#selector(currentTasksPressed), with: self)
        navBar.competedTasksAction(#selector(competedTasksPressed), with: self)

       
    }

    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // TODO: ??? bottomAnchor or heighAnchor
//            navBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            navBar.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    override func configureAppearance() {
        super.configureAppearance()
        
        navigationController?.navigationBar.isHidden = true

        title = App.Strings.NavBar.session
        navigationController?.tabBarItem.title = App.Strings.TabBar.title(for: .tasks)
    }
    
}

@objc extension TasksController {
    func currentTasksPressed() {
        navBar.changeTasksList(to: .current)
    }
    func competedTasksPressed() {
        navBar.changeTasksList(to: .completed)
    }
}
