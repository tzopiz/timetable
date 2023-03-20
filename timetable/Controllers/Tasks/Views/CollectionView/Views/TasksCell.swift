//
//  TasksCellView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

enum CellRoundedType {
    case top, bottom, all, notRounded
}
final class TasksCell: UICollectionViewCell {
    static let reuseID =  String(describing: TasksCell.self)
    private let checkmarkView = UIImageView(image: App.Images.checkmarkNotDone)
    private let stackView = UIStackView()
    private let title = UILabel()
    private let subtitle = UILabel()
    private let importance = UIImageView()

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
    func configure(with title: String, subtitle: String, isDone: Bool, importance: Int16) {
        self.title.text = title
        self.subtitle.text = subtitle
        checkmarkView.image = isDone ? App.Images.checkmarkDone : App.Images.checkmarkNotDone
        switch importance {
        case 1: self.importance.image = App.Images.exclamation_1
        case 2: self.importance.image = App.Images.exclamation_2
        case 3: self.importance.image = App.Images.exclamation_3
        default: self.importance.image = nil

        }
    }
    func isHighlighted() { self.backgroundColor = App.Colors.secondary.withAlphaComponent(0.4) }
    func isUnHighlighted() { self.backgroundColor = App.Colors.BlackWhite }
}

private extension TasksCell {
    func setupViews() {
        setupView(checkmarkView)
        setupView(stackView)
        setupView(importance)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)

    }

    func constaintViews() {
        checkmarkView.setDimensions(height: 28, width: 28)
        checkmarkView.anchor(left: leadingAnchor, paddingLeft: 16,
                             centerY: centerYAnchor)
        stackView.anchor(left: checkmarkView.trailingAnchor, paddingLeft: 16,
                         right: trailingAnchor, paddingRight: -16,
                         centerY: centerYAnchor)
        importance.anchor(right: trailingAnchor, paddingRight: -16,
                         centerY: centerYAnchor)
    }

    func configureAppearance() {
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 20
        
        stackView.axis = .vertical
        stackView.spacing = 3
        
        title.font = App.Fonts.helveticaNeue(with: 17)
        title.textColor = App.Colors.title
        
        subtitle.font = App.Fonts.helveticaNeue(with: 13)
        subtitle.textColor = App.Colors.inactive
    }
}
