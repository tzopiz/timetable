//
//  TaskViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 08.03.2023.
//

import UIKit

final class TaskViewController: TTBaseController {
    private let contentView = ContentView()
    var task: Task? = nil
    var completion: (() -> ())?
}
extension TaskViewController {
    override func setupViews() {
        view.setupView(contentView)
    }
    override func constraintViews() {
        contentView.anchor(top: view.topAnchor,
                           bottom: view.bottomAnchor,
                           left: view.leadingAnchor,
                           right: view.trailingAnchor)
    }
    override func configureAppearance() {
        super.configureAppearance()
        self.view.tintColor = App.Colors.active
        if let task = self.task {
            contentView.configure(label: task.isDone ? "Выполненная задача" : "Активаная задача",
                                  taskName: task.taskName, text: task.taskInfo,
                                  isDone: task.isDone, importance: task.importance)
        } else {
            contentView.configure(label: "Новая задача", isDone: false, true)
        }
        contentView.addTargetButtonSave(target: self, action: #selector(addButtonSave))
        contentView.addTargetButtonDelete(target: self, action: #selector(addButtonDelete))
    }
    @objc func addButtonSave() {
        let taskInfoDictionary = contentView.getTaskInfo()
        let taskName: String
        if (taskInfoDictionary["taskName"] as! String) == "" {
            taskName = "Безымянная"
        } else {
            taskName = (taskInfoDictionary["taskName"] as! String)
        }
        if (taskInfoDictionary["needCreate"] as? Bool ?? false) == true {
            CoreDataMamanager.shared.createTask(taskName: taskName,
                                                taskInfo: (taskInfoDictionary["taskInfo"] as! String),
                                                isDone: (taskInfoDictionary["isDone"] as! Bool),
                                                importance: (taskInfoDictionary["importance"] as! Int16))
        } else {
            CoreDataMamanager.shared.updataTask(with: self.task?.id,
                                                taskName: taskName,
                                                taskInfo: (taskInfoDictionary["taskInfo"] as! String),
                                                isDone: (taskInfoDictionary["isDone"] as! Bool),
                                                importance: (taskInfoDictionary["importance"] as! Int16))
        }
        self.dismiss(animated: true)
        completion?()
    }
    @objc func addButtonDelete() {
        CoreDataMamanager.shared.deletaTask(with: self.task?.id)
        self.dismiss(animated: true)
        completion?()
    }
}
