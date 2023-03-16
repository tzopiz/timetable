//
//  TasksController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

struct TaskData {
    struct Data {
        let taskName: String
        let textInfo: String
        let isDone: Bool
    }

    let date: Date
    let items: [Data]
}
enum TaskType {
    case active
    case all
}
class TasksController: TTBaseController {

    private let untiBag = UIView(frame: .zero)

    private var dataSource: [TaskData] = []
    private var tasks: [TaskData] = []
    private var currentType: TaskType = .active
    private func tasks(with type: TaskType) -> [TaskData] {
        var ans: [TaskData] = []
        switch type {
        case .active:
            for task in dataSource {
                var items: [TaskData.Data] = []
                for item in task.items where item.isDone == false {
                    items.append(item)
                }
                if !items.isEmpty {
                    ans.append(.init(date: task.date, items: items))
                }
            }
            return ans
        case .all:
            return dataSource
        }
    }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.backgroundColor = .clear

        return view
    }()
}

extension TasksController {
    override func setupViews() {
        super.setupViews()
        view.setupView(untiBag)
        view.setupView(collectionView)
    }

    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    override func configureAppearance() {
        super.configureAppearance()
        untiBag.isHidden = true
        title = App.Strings.tasks

        collectionView.register(TasksCell.self, forCellWithReuseIdentifier: TasksCell.reuseID)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.id)

        collectionView.delegate = self
        collectionView.dataSource = self
        addNavBarButton(at: .right, with: "Добавить")
        addNavBarButton(at: .left, with: "Активные")

        dataSource = [
            .init(date: Date(timeInterval: 1000000, since: .now),
                  items: [
                    .init(taskName: "Матан", textInfo: "2332, 2333, 2334, 2334, 2335", isDone: true),
                    .init(taskName: "Механика", textInfo: "232, 233, 234, 234, 235", isDone: true)
                  ]),
            .init(date: Date(timeInterval: -1000000, since: .now),
                  items: [
                    .init(taskName: "Матан", textInfo: "2432, 2433, 2434, 2434, 2435", isDone: false),
                    .init(taskName: "Механика", textInfo: "232, 233, 234, 234, 235", isDone: false),
                    .init(taskName: "Англ", textInfo: "пересказ статьи на 40к символов", isDone: false)
                  ]),
            .init(date: Date(timeInterval: -15000000, since: .now),
                  items: [
                    .init(taskName: "Матан", textInfo: "2332, 2333, 2334, 2334, 2335", isDone: false),
                    .init(taskName: "Англ", textInfo: "пересказ статьи на 30к символов", isDone: true)
                  ]),
            .init(date: Date(timeInterval: -500000, since: .now),
                  items: [
                    .init(taskName: "Матан", textInfo: "2332, 2333, 2334, 2334, 2335", isDone: false),
                    .init(taskName: "Механика", textInfo: "232, 233, 234, 234, 235", isDone: false),
                    .init(taskName: "Матан", textInfo: "2432, 2433, 2434, 2434, 2435", isDone: true),
                    .init(taskName: "Механика", textInfo: "232, 233, 234, 234, 235", isDone: false),
                    .init(taskName: "Англ", textInfo: "пересказ статьи на 40к символов", isDone: false)
                  ])
        ]
        tasks = tasks(with: .active)
        collectionView.reloadData()
    }
    override func navBarRightButtonHandler() {
        let taskVC = TaskViewController(needToCreate: true)
        present(taskVC, animated: true)
    }
    override func navBarLeftButtonHandler() {
        switch currentType {
        case .active:
            tasks = tasks(with: .all)
            currentType = .all
            navigationItem.leftBarButtonItems = nil
            addNavBarButton(at: .left, with: "Выполненные")
        case .all:
            tasks = tasks(with: .active)
            currentType = .active
            navigationItem.leftBarButtonItems = nil
            addNavBarButton(at: .left, with: "Активные")
        }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate
extension TasksController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        tasks.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tasks[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TasksCell.reuseID, for: indexPath
        ) as? TasksCell else { return UICollectionViewCell() }

        let item = tasks[indexPath.section].items[indexPath.row]

        cell.configure(with: item.taskName, subtitle: item.textInfo, isDone: item.isDone)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: SectionHeaderView.id, for: indexPath
        ) as? SectionHeaderView else { return UICollectionReusableView() }

        view.configure(with: tasks[indexPath.section].date)
        return view
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = tasks[indexPath.section].items[indexPath.row]
        let taskVC = TaskViewController(taskName: item.taskName,
                                        textInfo: item.textInfo,
                                        isDone: item.isDone,
                                        needToCreate: false)
        present(taskVC, animated: true)
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
extension TasksController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 32)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == tasks.count - 1 {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 16.0, right: 0.0)
        } else {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 8
    }
}
