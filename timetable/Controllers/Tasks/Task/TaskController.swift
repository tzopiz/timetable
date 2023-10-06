//
//  TaskController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 08.03.2023.
//

import UIKit

final class TaskController: TTBaseController {
    private let contentView = ContentView()
    var task: Task? = nil
    var completion: ((Bool) -> ())?
}

extension TaskController {
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
            contentView.configure(label: task.isDone ? App.Strings.completeTask : App.Strings.activeTask,
                                  taskName: task.taskName, text: task.taskInfo,
                                  isDone: task.isDone, importance: task.isImportant, deadline: task.deadline)
        } else { contentView.configure(label: App.Strings.newTask, isDone: false, true) }
        contentView.addTargetButtonSave(target: self, action: #selector(saveTask))
        contentView.addTargetButtonDelete(target: self, action: #selector(deleteTask))
    }
}

extension TaskController {
    @IBAction func saveTask() {
//        let taskInfoDictionary = contentView.getTaskInfo()
//        let taskName: String?
//        if (taskInfoDictionary["taskName"] as? String) == "" { taskName = App.Strings.untitle }
//        else { taskName = (taskInfoDictionary["taskName"] as? String) }
//        print("save task")
//        self.dismiss(animated: true)
//        completion?(true)
        print(#function)
    }
    @IBAction func deleteTask() {
//        CoreDataMamanager.shared.deletaTask(with: self.task?.id)
//        self.dismiss(animated: true)
//        completion?(false)
        print(#function)
    }
}
