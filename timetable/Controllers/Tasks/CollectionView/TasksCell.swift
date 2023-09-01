//
//  TasksCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class TasksCell: BaseCell {
    
    override class var reuseIdentifier: String { return String(describing: TasksCell.self) }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    private let noteNameLabel = TTLabel(fontSize: 17)
    private let noteInfoLabel = TTLabel(textColor: App.Colors.text_2, fontSize: 15)
    private let deadlineLabel = TTLabel(fontSize: 13)
    private let importance = UIImageView()
    private let buttonCheckmarkView = TTButton(with: .primary)
    
    private var task: Task?
    
    var completion: (() -> ())?

    func configure(task: Task) {
        self.task = task
        self.noteNameLabel.text = task.taskName
        self.noteInfoLabel.text = task.taskInfo
        buttonCheckmarkView.setImage(task.isDone ? App.Images.checkmarkDone : App.Images.checkmarkNotDone, for: .normal)
        switch task.importance {
        case 1: self.importance.image = App.Images.exclamation_1
        case 2: self.importance.image = App.Images.exclamation_2
        case 3: self.importance.image = App.Images.exclamation_3
        default: self.importance.image = nil
        }
        if let deadline = task.deadline {
            deadlineLabel.isHidden = false
            let calendar = Calendar.current
            if calendar.isDateInToday(deadline) {
                deadlineLabel.text = "Дедлайн сегодня: " + Date().formattedDeadline(deadline)
                deadlineLabel.textColor = App.Colors.red
            }
            else {
                deadlineLabel.text = "Дедлайн: " + Date().formattedDeadline(deadline)
                deadlineLabel.textColor = App.Colors.active
            }
        } else {
            deadlineLabel.isHidden = true
            deadlineLabel.text = nil
        }
        noteInfoLabel.isHidden = false
        if task.taskInfo == "" { noteInfoLabel.isHidden = true }
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

extension TasksCell {
    override func setupViews() {
        setupView(buttonCheckmarkView)
        setupView(stackView)
        setupView(importance)
        
        stackView.addArrangedSubview(noteNameLabel)
        stackView.addArrangedSubview(noteInfoLabel)
        stackView.addArrangedSubview(deadlineLabel)
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
    }
    override func configureAppearance() {
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 16
        
        buttonCheckmarkView.addTarget(self, action: #selector(updateCheckmarkView), for: .touchUpInside)
    }
}
