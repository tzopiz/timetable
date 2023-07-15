//
//  TasksCellView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class TasksCell: UICollectionViewCell {
    
    static let reuseIdentifier =  String(describing: TasksCell.self)
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.helveticaNeue(with: 17)
        label.textColor = App.Colors.text
        return label
    }()
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.helveticaNeue(with: 13)
        label.textColor = App.Colors.inactive
        return label
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    private let importance = UIImageView()
    private let notificationButton = TTButton(with: .primary)
    private let buttonCheckmarkView = TTButton(with: .primary)
    private var task: Task?
    private var deadline: String = ""
    var completion: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        constaintViews()
        configureAppearance()
    }
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupViews()
        constaintViews()
        configureAppearance()
    }
    
    func configure(task: Task) {
        self.task = task
        self.title.text = task.taskName
        self.subtitle.text = task.taskInfo
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
    
    func isHighlighted() { self.backgroundColor = App.Colors.secondary.withAlphaComponent(0.4) }
    func isUnHighlighted() { self.backgroundColor = App.Colors.BlackWhite }

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

private extension TasksCell {
    func setupViews() {
        setupView(buttonCheckmarkView)
        setupView(stackView)
        setupView(importance)
        setupView(notificationButton)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)
    }
    func constaintViews() {
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
    func configureAppearance() {
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 16
        
        buttonCheckmarkView.addTarget(self, action: #selector(updateCheckmarkView), for: .touchUpInside)
        notificationButton.showsMenuAsPrimaryAction = true
    }
}
