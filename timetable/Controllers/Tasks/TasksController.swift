//
//  TasksController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

struct TaskData {
    struct Data {
        let title: String
        let subtitle: String
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
                var _items: [TaskData.Data] = []
                for item in task.items {
                    if item.isDone == false {
                        _items.append(item)
                    }
                }
                if !_items.isEmpty {
                    ans.append(.init(date: task.date, items: _items))
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
        title = App.Strings.NavBar.tasks

        collectionView.register(TasksCellView.self, forCellWithReuseIdentifier: TasksCellView.id)
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
                    .init(title: "Матан", subtitle: "2332, 2333, 2334, 2334, 2335", isDone: true),
                    .init(title: "Механика", subtitle: "232, 233, 234, 234, 235", isDone: true)
                  ]),
            .init(date: Date(timeInterval: -1000000, since: .now),
                  items: [
                    .init(title: "Матан", subtitle: "2432, 2433, 2434, 2434, 2435", isDone: false),
                    .init(title: "Механика", subtitle: "232, 233, 234, 234, 235", isDone: false),
                    .init(title: "Англ", subtitle: "пересказ статьи на 40к символов", isDone: false)
                  ]),
            .init(date: Date(timeInterval: -15000000, since: .now),
                  items: [
                    .init(title: "Матан", subtitle: "2332, 2333, 2334, 2334, 2335", isDone: false),
                    .init(title: "Англ", subtitle: "пересказ статьи на 30к символов", isDone: true)
                  ]),
            .init(date: Date(timeInterval: -500000, since: .now),
                  items: [
                    .init(title: "Матан", subtitle: "2332, 2333, 2334, 2334, 2335", isDone: false),
                    .init(title: "Механика", subtitle: "232, 233, 234, 234, 235", isDone: false),
                    .init(title: "Матан", subtitle: "2432, 2433, 2434, 2434, 2435", isDone: true),
                    .init(title: "Механика", subtitle: "232, 233, 234, 234, 235", isDone: false),
                    .init(title: "Англ", subtitle: "пересказ статьи на 40к символов", isDone: false)
                  ]),
            
        ]
        tasks = tasks(with: .active)
        collectionView.reloadData()
    }
    
    override func navBarRightButtonHandler() {
        let vc = TaskViewController()
        vc.view.backgroundColor = App.Colors.background
        vc.view.tintColor = App.Colors.active
        present(vc, animated: true)
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

// MARK: - UICollectionViewDataSource
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
            withReuseIdentifier: TasksCellView.id, for: indexPath
        ) as? TasksCellView else { return UICollectionViewCell() }

        let item = tasks[indexPath.section].items[indexPath.row]

        let roundedType: CellRoundedType
//        if indexPath.row == 0 && indexPath.row == tasks[indexPath.section].items.count - 1 {
//            roundedType = .all
//        } else if indexPath.row == 0 {
//            roundedType = .top
//        } else if indexPath.row == tasks[indexPath.section].items.count - 1 {
//            roundedType = .bottom
//        } else {
//            roundedType = .notRounded
//        }
        roundedType = .notRounded

        cell.configure(with: item.title, subtitle: item.subtitle, isDone: item.isDone, roundedType: roundedType)
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
}
