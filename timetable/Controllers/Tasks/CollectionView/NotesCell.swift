//
//  NotesCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class NotesCell: BaseCell {
    
    override class var reuseIdentifier: String { return String(describing: NotesCell.self) }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    private let taskNameLabel = TTLabel(fontSize: 17)
    private let taskInfoLabel = TTLabel(textColor: App.Colors.text_2, fontSize: 13)
    private let importance = UIImageView()
    private let notificationButton = TTButton(with: .primary)
    private let buttonCheckmarkView = TTButton(with: .primary)
    
    private var task: Task?
    private var deadline: String = ""
    
    var completion: (() -> ())?

    func configure(task: Task) {
        self.task = task
        self.taskNameLabel.text = task.taskName
        self.taskInfoLabel.text = task.taskInfo
        buttonCheckmarkView.setImage(task.isDone ? App.Images.checkmarkDone : App.Images.checkmarkNotDone, for: .normal)
        switch task.importance {
        case 1: self.importance.image = App.Images.exclamation_1
        case 2: self.importance.image = App.Images.exclamation_2
        case 3: self.importance.image = App.Images.exclamation_3
        default: self.importance.image = nil
        }
        if task.deadline != nil {
            var imageNotification: UIImage = App.Images.notification
            UIImage.resizeImage(image: &imageNotification, targetSize: CGSizeMake(8, 8))
            notificationButton.setImage(imageNotification, for: .normal)
            self.deadline = "\(task.deadline!)".components(separatedBy: " ").first ?? "\(Date())"
            let buttonMenu = UIMenu(
                title: "", children:[
                    UIAction(title: NSLocalizedString(self.deadline, comment: ""),
                             image: nil,
                             handler: handler)
            ])
            notificationButton.menu = buttonMenu
        } else {
            notificationButton.setImage(nil, for: .normal)
            notificationButton.menu = nil
        }
    }
    
    override func isHighlighted() { self.backgroundColor = App.Colors.secondary.withAlphaComponent(0.4) }
    override func isUnHighlighted() { self.backgroundColor = App.Colors.BlackWhite }

    @IBAction func updateCheckmarkView() {
        guard let task = self.task else { return }
        task.isDone = !task.isDone
        self.buttonCheckmarkView.setImage(task.isDone ? App.Images.checkmarkDone : App.Images.checkmarkNotDone,
                                          for: .normal)
        CoreDataMamanager.shared.updataTypeTask(with: task.id, isDone: task.isDone)
        self.task = task
        completion?()
    }
    private func handler(action: UIAction) {}
}

extension NotesCell {
    override func setupViews() {
        setupView(buttonCheckmarkView)
        setupView(stackView)
        setupView(importance)
        setupView(notificationButton)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(taskInfoLabel)
    }
    override func constraintViews() {
        buttonCheckmarkView.setDimensions(height: 28, width: 28)
        buttonCheckmarkView.anchor(left: leadingAnchor, paddingLeft: 16,
                             centerY: centerYAnchor)
        stackView.anchor(left: buttonCheckmarkView.trailingAnchor, paddingLeft: 16,
                         right: trailingAnchor, paddingRight: -16,
                         centerY: centerYAnchor)
        importance.anchor(right: trailingAnchor, paddingRight: -16,
                         centerY: centerYAnchor)
        notificationButton.setDimensions(height: 32, width: 32)
        notificationButton.anchor(right: importance.leadingAnchor, paddingRight: -16,
                         centerY: centerYAnchor)
    }
    override func configureAppearance() {
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 16
        
        buttonCheckmarkView.addTarget(self, action: #selector(updateCheckmarkView), for: .touchUpInside)
        notificationButton.showsMenuAsPrimaryAction = true
    }
}
