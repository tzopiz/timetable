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

final class TasksCellView: UICollectionViewCell {
    
    var isDone = false
    static let id = "TasksCellView"
    
    private let checkmarkView = UIImageView(image: App.Images.Overview.checkmarkNotDone)
    private let rightArrowView = UIImageView(image: App.Images.Overview.rightArrow)
    
    private let buttonCheckmark: UIButton = {
        let button = UIButton()
        return button
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 3
        return view
    }()

    private let title: UILabel = {
        let lable = UILabel()
        lable.font = App.Fonts.helveticaNeue(with: 17)
        lable.textColor = App.Colors.titleGray
        return lable
    }()

    private let subtitle: UILabel = {
        let lable = UILabel()
        lable.font = App.Fonts.helveticaNeue(with: 13)
        lable.textColor = App.Colors.inactive
        return lable
    }()

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

    func configure(with title: String, subtitle: String, isDone: Bool, roundedType: CellRoundedType) {
        self.title.text = title
        self.subtitle.text = subtitle

        checkmarkView.image = isDone ? App.Images.Overview.checkmarkDone : App.Images.Overview.checkmarkNotDone
        buttonCheckmark.setImage(checkmarkView.image, for: .normal)
        
        switch roundedType {
        case .all: self.roundCorners([.allCorners], radius: 5)
        case .bottom: self.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        case .top: self.roundCorners([.topLeft, .topRight], radius: 5)
        case .notRounded: self.roundCorners([.allCorners], radius: 0)
        }
    }
    
}

private extension TasksCellView {
    func setupViews() {
        
        setupView(buttonCheckmark)
        setupView(stackView)
        setupView(rightArrowView)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)

    }

    func constaintViews() {
        NSLayoutConstraint.activate([
            buttonCheckmark.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            buttonCheckmark.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonCheckmark.heightAnchor.constraint(equalToConstant: 28),
            buttonCheckmark.widthAnchor.constraint(equalTo: buttonCheckmark.heightAnchor),

            stackView.leadingAnchor.constraint(equalTo: buttonCheckmark.trailingAnchor, constant: 15),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: rightArrowView.leadingAnchor, constant: -15),

            rightArrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightArrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            rightArrowView.heightAnchor.constraint(equalToConstant: 12),
            rightArrowView.widthAnchor.constraint(equalToConstant: 7),
        ])
    }

    func configureAppearance() {
        backgroundColor = .white
    }
}

