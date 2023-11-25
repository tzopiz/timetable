//
//  TasksController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class TasksController: TTBaseController {
    
    private var taskSortKey: App.TaskSortKey = UserDefaults.standard.taskSortKey
    private let menuButton: TTButton = {
        let button = TTButton(with: .primary)
        button.setImage(UIImage(systemName: "arrow.up.and.down.text.horizontal"), for: .normal)
        button.tintColor = R.color.active()
        return button
    }()
}

// MARK: - Configure

extension TasksController {
    override func configureViews() {
        super.configureViews()
        navigationItem.title = App.Strings.tasks
        navigationController?.navigationBar.addBottomBorder(with: R.color.separator(), height: 1)
        
        collectionView.register(TasksCell.self, forCellWithReuseIdentifier: TasksCell.reuseIdentifier)
        collectionView.register(SectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: SectionView.reuseIdentifier)
        
        collectionView.refreshControl = nil
        
        addNavBarButton(at: .right, image: UIImage(systemName: "plus"))
        
        let taskSortKeyActions: [UIAction] = {
            var actions = [UIAction]()
            for taskSortKey in App.TaskSortKey.allCases {
                let title = taskSortKey.title
                
                let action = UIAction(title: title, handler: { [self] _ in
                    UserDefaults.standard.taskSortKey = taskSortKey
                    self.taskSortKey = UserDefaults.standard.taskSortKey
                    updateCollectionView()
                })
                
                if self.taskSortKey == taskSortKey { action.state = .on } // ставим галочку у текущей
                
                actions.append(action)
            }
            return actions
        }()
        
        menuButton.menu = UIMenu(title: "Сортировка", options: .singleSelection, children: taskSortKeyActions)
        menuButton.showsMenuAsPrimaryAction = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        
    }
    override func navBarRightButtonHandler() {
        CoreDataMamanager.shared.createTask { [weak self] task  in
            guard let self = self else { return }
            let taskVC = TaskController(with: task)
            taskVC.delegate = self
            navigationController?.pushViewController(taskVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension TasksController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { CoreDataMamanager.shared.fetchTasksDefined(with: taskSortKey).count }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TasksCell.reuseIdentifier, for: indexPath
        ) as? TasksCell else { return UICollectionViewCell() }
        let task = CoreDataMamanager.shared.fetchTasksDefined(with: taskSortKey)[indexPath.row]
        cell.configure(task: task)
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let task = CoreDataMamanager.shared.fetchTasksDefined(with: taskSortKey)[indexPath.row]
        let taskVC = TaskController(with: task)
        navigationController?.pushViewController(taskVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: SectionView.reuseIdentifier, for: indexPath) as? SectionView
            else { return UICollectionReusableView() }
            footerView.configure(with: UserDefaults.standard.taskSortKey.title, textSize: 13)
            
            return footerView
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.width - 32
        if CoreDataMamanager.shared.fetchTasksDefined(with: taskSortKey).count == 0 { return CGSize(width: width, height: 0) }
        else { return CGSize(width: width, height: 10) }
        
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
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = CoreDataMamanager.shared.fetchTasksDefined(with: taskSortKey)[indexPath.row]
        if let _ = item.deadline, item.info != "" { return CGSize(width: collectionView.frame.width - 32, height: 90) }
        else if item.deadline == nil, item.info == "" {return CGSize(width: collectionView.frame.width - 32, height: 60) }
        else { return CGSize(width: collectionView.frame.width - 32, height: 70) }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 16, left: 0.0, bottom: 16.0, right: 0.0) }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: 0, height: 0) }
}
