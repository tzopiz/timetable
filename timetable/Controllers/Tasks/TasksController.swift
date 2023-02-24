//
//  TasksController.swift
//  timtable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

var completedTasks = [
        "completedtask1",
        "completedtask2",
        "completedtask3",
        "completedtask4",
        "completedtask5"
]
var activeTasks = [
        "сделать англ",
        "activeTaskstask2",
        "activeTaskstask3",
        "activeTaskstask4",
        "activeTaskstask5"
]

class TasksController: TTBaseController {
    
    
    private let navBar = TasksNavBar()
    private let activeTasksTableView = ActiveTasksTimeTableView(frame: .zero, style: .insetGrouped)
    private let completedTasksTableView = CompletedTasksTableView(frame: .zero, style: .insetGrouped)
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(App.Images.Common.add, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        return button
    }()
    
}

extension TasksController {
    override func setupViews() {
        super.setupViews()

        view.setupView(navBar)
        view.setupView(activeTasksTableView)
        view.setupView(completedTasksTableView)
        view.setupView(addButton)

        navBar.currentTasksAction(#selector(currentTasksPressed), with: self)
        navBar.competedTasksAction(#selector(competedTasksPressed), with: self)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
       
    }

    override func constraintViews() {
        super.constraintViews()
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // TODO: ??? bottomAnchor or heighAnchor
//            navBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            navBar.heightAnchor.constraint(equalToConstant: 90),
            
            activeTasksTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            activeTasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activeTasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activeTasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            completedTasksTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            completedTasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            completedTasksTableView.leadingAnchor.constraint(equalTo: view.trailingAnchor),
            completedTasksTableView.widthAnchor.constraint(equalToConstant: view.frame.width),
            

            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addButton.widthAnchor.constraint(equalToConstant: 66),
            addButton.heightAnchor.constraint(equalToConstant: 66)
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
        navBar.changeTasksList(to: .active, with: [completedTasksTableView, activeTasksTableView], button: addButton)
    }
    func competedTasksPressed() {
        navBar.changeTasksList(to: .completed, with: [completedTasksTableView, activeTasksTableView], button: addButton)
    }
    func addButtonPressed(){
        activeTasks.append("New task")
        activeTasksTableView.reloadData()
    }
}
