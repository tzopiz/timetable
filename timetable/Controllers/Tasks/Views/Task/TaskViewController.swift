//
//  TaskViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 08.03.2023.
//

import UIKit

final class TaskViewController: TTBaseController {
    private let contentView = ContentView()
    
    init(taskName: String? = nil, taskInfo: String = "", isDone: Bool = false, needToCreate: Bool) {
        super.init(nibName: nil, bundle: nil)
        if let title = taskName {
            contentView.configure(label: isDone ? "Выполненная задача": "Активная задача",
                                  nameTask: title, text: taskInfo, isDone: isDone)
        } else {
            contentView.configure(label: "Новая задача", nameTask: "", text: taskInfo, isDone: isDone)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
        
        contentView.addTargetButtonSave(target: self, action: #selector(addButtonSave))
        contentView.addTargetButtonDelete(target: self, action: #selector(addButtonDelete))
        contentView.addTargetButtonComplete(target: self, action: #selector(addButtonComplete))
    }
    @objc func addButtonSave() {
        self.dismiss(animated: true)
        // TODO: save task
    }
    @objc func addButtonDelete() {
        self.dismiss(animated: true)
        // TODO: delete task
    }
    @objc func addButtonComplete() {
        self.dismiss(animated: true)
        // TODO: change status task
    }
}
