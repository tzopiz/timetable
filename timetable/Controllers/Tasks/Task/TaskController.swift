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
        mainView.anchor(top: view.topAnchor, paddingTop: 16,
                        bottom: view.bottomAnchor, paddingBottom: -16,
                        left: view.leadingAnchor, paddingLeft: 16,
                        right: view.trailingAnchor, paddingRight: -16)
    }
    override func configureAppearance() {
        super.configureAppearance()
        self.view.tintColor = App.Colors.active
        
        mainView.updateDelegate = delegate
        mainView.actionDelegate = self
        mainView.configure(with: task)
        
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
