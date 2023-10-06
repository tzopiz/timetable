//
//  TaskController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 08.03.2023.
//

import UIKit

final class TaskController: TTBaseController {
    
    private let mainView = MainView()
    weak var delegate: UICollectionViewUpdatable?
    var task: Task
    
    init(with task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskController {
    override func setupViews() {
        view.setupView(mainView)
    }
    override func constraintViews() {
        mainView.anchor(top: view.topAnchor,
                           bottom: view.bottomAnchor,
                           left: view.leadingAnchor,
                           right: view.trailingAnchor)
    }
    override func configureAppearance() {
        super.configureAppearance()
        self.view.tintColor = App.Colors.active
        
        mainView.updateDelegate = delegate
        mainView.actionDelegate = self
        mainView.configure(with: task)
        
//        contentView.configure(label: task.isDone ? App.Strings.completeTask : App.Strings.activeTask,
//                              taskName: task.taskName, text: task.taskInfo,
//                              isDone: task.isDone, importance: task.isImportant, deadline: task.deadline)
        
    }
}

// MARK: - CustomViewActionDelegate

protocol CustomViewActionDelegate: AnyObject {
    func didTapDismissButton(completion: @escaping () -> Void)
}

extension TaskController: CustomViewActionDelegate {
    func didTapDismissButton(completion: @escaping () -> Void) {
        dismiss(animated: true) { completion() }
    }
}
