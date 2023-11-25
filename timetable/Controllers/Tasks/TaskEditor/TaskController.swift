//
//  TaskController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 08.03.2023.
//

import UIKit
import SnapKit

final class TaskController: TTBaseController {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private var taskInfoView = TaskInfoView()
    
    private var importanceChangeItem: UIBarButtonItem?
    private var isDelete: Bool = false
    weak var delegate: UICollectionViewUpdatable?
    var task: Task
    
    init(with task: Task) {
        self.task = task
        taskInfoView.configure(name: task.name, info: task.info)
        super.init(nibName: nil, bundle: nil)
        importanceChangeItem = UIBarButtonItem(image: task.isImportant ? R.image.star_fill() : R.image.star(),
                                               style: .done, target: self,
                                               action: #selector(importanceChangeItemAction))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure

extension TaskController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateTask()
    }
    override func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(taskInfoView)
    }
    override func layoutViews() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    override func configureViews() {
        super.configureViews()
        
        title = "Задача"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .done, target: self,
                                                           action: #selector(backButtonAction))
        
        let menuButton = UIButton()
        menuButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        menuButton.menu = UIMenu(options: .displayInline, children: menuActions())
        menuButton.showsMenuAsPrimaryAction = true
        
        guard let importanceChangeItem = importanceChangeItem else { return }
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: menuButton), importanceChangeItem]
    }
}

extension TaskController {
    private func updateTask() {
        if !isDelete {
            let (newName, newInfo) = taskInfoView.retrieveData()
            
            self.task.name = newName
            self.task.info = newInfo
            CoreDataMamanager.shared.save()
        }
    }
    private func menuActions() -> [UIAction] {
        let actionCopy = UIAction(title: "Копировать", image: UIImage(systemName: "doc.on.doc")) { _ in
            UIPasteboard.general.string = self.task.formattedDescription()
        }
        let actionDuplicate = UIAction(title: "Дублировать", image: UIImage(systemName: "plus.square.on.square")) { _ in
            let alertController = UIAlertController(title: "Подтверждение", message: "Вы точно хотите создать дубликат задачи?",
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            let confirmAction = UIAlertAction(title: "Да", style: .default) { _ in
                CoreDataMamanager.shared.createDuplicate(of: self.task)
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
        let actionNotification = UIAction(title: "Уведомление", image: UIImage(systemName: "bell")) { _ in
            let dataPickerVC = DataPickerController()
            dataPickerVC.modalPresentationStyle = .custom
            dataPickerVC.transitioningDelegate = self
            self.present(dataPickerVC, animated: true)
            
            if self.task.deadline == nil {
                let calendar = Calendar.current
                let deadline = calendar.date(byAdding: .day, value: Int.random(in: 0...5), to: Date())
                CoreDataMamanager.shared.updataDeadlineTask(with: self.task.id, deadline: deadline)
            } else {
                CoreDataMamanager.shared.updataDeadlineTask(with: self.task.id, deadline: nil)
            }
        }
        let actionDelete = UIAction(title: "Удалить", image: UIImage(systemName: "trash")) { _ in
            let alertController = UIAlertController(title: "Подтверждение",
                                                    message: "Вы точно хотите удалить задачу?",
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            let confirmAction = UIAlertAction(title: "Да", style: .default) { _ in
                CoreDataMamanager.shared.deleteTask(with: self.task.id)
                self.isDelete = true
                self.navigationController?.popViewController(animated: true)
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
        let actionShare = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            print("actionShare")
        }
        return [actionCopy, actionDuplicate, actionNotification, actionDelete, actionShare]
    }
}

extension TaskController {
    @IBAction func backButtonAction() {
        self.updateTask()
        self.delegate?.updateCollectionView()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func importanceChangeItemAction() {
        task.isImportant.toggle()
        importanceChangeItem?.image = task.isImportant ? R.image.star_fill() : R.image.star()
    }
}

extension TaskController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
}
