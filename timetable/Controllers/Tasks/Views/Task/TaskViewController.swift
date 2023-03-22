//
//  TaskViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 08.03.2023.
//

import UIKit

final class TaskViewController: TTBaseController {
    private let contentView = ContentView()
    var taskData: Task? = nil
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
        if let task = taskData {
            contentView.configure(label: task.isDone ? "Выполненная задача" : "Активаная задача",
                                  taskName: task.taskName ?? "", text: task.taskInfo ?? "",
                                  isDone: task.isDone, importance: task.importance)
        } else {
            contentView.configure(label: "Новая задача", isDone: false, true)
        }
        contentView.addTargetButtonSave(target: self, action: #selector(addButtonSave))
        contentView.addTargetButtonDelete(target: self, action: #selector(addButtonDelete))
        contentView.addTargetButtonComplete(target: self, action: #selector(addButtonComplete))
    }
    @objc func addButtonSave() {
        let task = contentView.getTask()
        if (task["needCreate"] as? Bool ?? false) == true {
            CoreDataMamanager.shared.createTask(taskName: task["taskName"] as? String ?? "",
                                                taskInfo: task["taskInfo"] as? String ?? "",
                                                isDone: task["isDone"] as? Bool ?? false,
                                                importance: task["importance"] as? Int16 ?? 0)
        } else {
            CoreDataMamanager.shared.updataTask(with: taskData?.id ?? UUID(),
                                                taskName: task["taskName"] as? String ?? "",
                                                taskInfo: task["taskInfo"] as? String ?? "",
                                                isDone: task["isDone"] as? Bool ?? false,
                                                importance: task["importance"] as? Int16 ?? 0)
        }
        self.dismiss(animated: true)
        completion?()
    }
    @objc func addButtonDelete() {
        CoreDataMamanager.shared.deletaTask(with: taskData?.id ?? UUID())
        self.dismiss(animated: true)
        completion?()
    }
    @objc func addButtonComplete() {
        taskData?.isDone = !(taskData?.isDone ?? false)
        let task = contentView.getTask()
        if (task["needCreate"] as? Bool ?? false) == true {
            CoreDataMamanager.shared.createTask(taskName: task["taskName"] as? String ?? "",
                                                taskInfo: task["taskInfo"] as? String ?? "",
                                                isDone: true,
                                                importance: task["importance"] as? Int16 ?? 1)
        } else {
            CoreDataMamanager.shared.updataTask(with: taskData?.id ?? UUID(),
                                                taskName: task["taskName"] as? String ?? "",
                                                taskInfo: task["taskInfo"] as? String ?? "",
                                                isDone: (taskData?.isDone ?? false),
                                                importance: task["importance"] as? Int16 ?? 1)
        }
        self.dismiss(animated: true)
        completion?()
    }
}
