//
//  TasksController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit
import SwiftUI

final class TasksController: TTBaseController {
    private var currentType: App.TaskType = UserDefaults.standard.taskType.getUserTaskType()
}

// MARK: - Configure

extension TasksController {
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = App.Strings.tasks
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(TasksCell.self, forCellWithReuseIdentifier: TasksCell.reuseIdentifier)
        
        addNavBarButton(at: .right, with: "Добавить")
        switch currentType {
        case .active: addNavBarButton(at: .left, with: "Активные")
        case .all: addNavBarButton(at: .left, with: "Все")
        }
        collectionView.refreshControl = nil
    }
    override func navBarRightButtonHandler() {
        CoreDataMamanager.shared.createTask(taskName: "", taskInfo: "",
                                            isDone: false, importance: 0, deadline: nil) { [weak self] task in
            var newtask = task
            let taskEditController = NoteEditHostingController(
                task: Binding<Task>(
                    get: { newtask },
                    set: { newtask = $0 }
                )
            ) { self?.collectionView.reloadData() }
            
            taskEditController.modalPresentationStyle = .formSheet
            self?.present(taskEditController, animated: true)
        }
    }
    override func navBarLeftButtonHandler() {
        switch currentType {
        case .active:
            UserDefaults.standard.taskType = .all
            navigationItem.leftBarButtonItems = nil
            addNavBarButton(at: .left, with: "Все")
        case .all:
            UserDefaults.standard.taskType = .active
            navigationItem.leftBarButtonItems = nil
            addNavBarButton(at: .left, with: "Активные")
        }
        currentType = UserDefaults.standard.taskType.getUserTaskType()
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension TasksController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { CoreDataMamanager.shared.fetchTasksDefined(with: currentType).count }

    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TasksCell.reuseIdentifier, for: indexPath
        ) as? TasksCell else { return UICollectionViewCell() }
        let task = CoreDataMamanager.shared.fetchTasksDefined(with: currentType)[indexPath.row]
        cell.configure(task: task)
        cell.completion = { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var task = CoreDataMamanager.shared.fetchTasksDefined(with: currentType)[indexPath.row]
        let noteEditController = NoteEditHostingController(
            task: Binding<Task>(
                get: { task },
                set: { task = $0 }
            )
        ){ self.collectionView.reloadData()  }
        noteEditController.modalPresentationStyle = .formSheet
        present(noteEditController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? TasksCell
        cell?.isHighlighted()
    }
    func collectionView(_ collectionView: UICollectionView,
                        didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? TasksCell
        cell?.isUnHighlighted()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TasksController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize { CGSize(width: collectionView.frame.width - 32, height: 70) }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 16, left: 0.0, bottom: 16.0, right: 0.0) }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
     -> CGSize { CGSize(width: 0, height: 0) }
}
