//
//  TasksController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

struct TasksData {
    struct Data {
        let title: String
        let subtitle: String
        let isDone: Bool
    }

    let date: Date
    let items: [Data]
}



class TasksController: TTBaseController {
    
    private var tasks: [TasksData] = []
    
    private let navBar = TasksNavBar()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(App.Images.Common.add, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .clear
        return button
    }()
    private let activeTasksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear

        return view
    }()
    private let completedTasksCollectionView: UICollectionView = {
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
        view.setupView(navBar)
        view.setupView(activeTasksCollectionView)
        view.setupView(completedTasksCollectionView)
        view.setupView(addButton)
        navBar.currentTasksAction(#selector(currentTasksPressed), with: self)
        navBar.competedTasksAction(#selector(competedTasksPressed), with: self)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }

    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 90),

            activeTasksCollectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            activeTasksCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            activeTasksCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            activeTasksCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            completedTasksCollectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            completedTasksCollectionView.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            completedTasksCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            completedTasksCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            addButton.heightAnchor.constraint(equalToConstant: 68),
            addButton.widthAnchor.constraint(equalToConstant: 68)

        ])
    }

    override func configureAppearance() {
        super.configureAppearance()
        
        navigationController?.navigationBar.isHidden = true

        activeTasksCollectionView.register(TasksCellView.self, forCellWithReuseIdentifier: TasksCellView.id)
        activeTasksCollectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.id)

        activeTasksCollectionView.delegate = self
        activeTasksCollectionView.dataSource = self

        tasks = [
            .init(date: Date(),
                  items: [
                    .init(title: "Warm Up Cardio", subtitle: "Stair Climber • 10 minutes", isDone: true),
                    .init(title: "High Intensity Cardio", subtitle: "Treadmill • 50 minutes", isDone: false),
                  ]),
            .init(date: Date(),
                  items: [
                    .init(title: "Warm Up Cardio", subtitle: "Stair Climber • 10 minutes", isDone: false),
                    .init(title: "Chest Workout", subtitle: "Bench Press • 3 sets • 10 reps", isDone: false),
                    .init(title: "Tricep Workout", subtitle: "Overhead Extension • 5 sets • 8 reps", isDone: false),
                  ]),
            .init(date: Date(),
                  items: [
                    .init(title: "Cardio Interval Workout", subtitle: "Treadmill • 60 minutes", isDone: false),
                  ])
        ]
        activeTasksCollectionView.reloadData()
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TasksCellView.id, for: indexPath) as? TasksCellView else { return UICollectionViewCell() }

        let item = tasks[indexPath.section].items[indexPath.row]
        let roundedType: CellRoundedType
        
        if indexPath.row == 0 && indexPath.row == tasks[indexPath.section].items.count - 1 {
            roundedType = .all
        } else if indexPath.row == 0 {
            roundedType = .top
        } else if indexPath.row == tasks[indexPath.section].items.count - 1 {
            roundedType = .bottom
        } else {
            roundedType = .notRounded
        }

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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 32)
    }
}


@objc extension TasksController {
    func currentTasksPressed() {
        navBar.changeTasksList(to: .active, with: [activeTasksCollectionView, completedTasksCollectionView], button: addButton)
    }
    func competedTasksPressed() {
        navBar.changeTasksList(to: .completed, with: [activeTasksCollectionView, completedTasksCollectionView], button: addButton)
    }
    func addButtonPressed(){
        tasks.append( .init(date: Date(),
                            items: [.init(title: "Warm Up Cardio", subtitle: "Stair Climber • 10 minutes", isDone: true)]))
        activeTasksCollectionView.reloadData()
    }
}
