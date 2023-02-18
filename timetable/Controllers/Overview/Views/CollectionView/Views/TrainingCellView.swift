//
//  TrainingCellView.swift
//  WorkoutApp
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class TrainingCellView: UICollectionViewCell {
    
    static let id = "TrainingCellView"

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        return view
    }()

    private let title: UILabel = {
        let lable = UILabel()
        lable.font = App.Fonts.menloRegular(with: 14)
        lable.textColor = App.Colors.inactive
        return lable
    }()
    private let subtitle: UILabel = {
        let lable = UILabel()
        lable.font = App.Fonts.menloRegular(with: 17)
        lable.textColor = App.Colors.titleGray
        return lable
    }()
    private let teacher: UILabel = {
        let lable = UILabel()
        lable.font = App.Fonts.menloRegular(with: 14)
        lable.textColor = App.Colors.inactive
        return lable
    }()
    private let classroom: UILabel = {
        let lable = UILabel()
        lable.font = App.Fonts.menloRegular(with: 14)
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

    func configure(with title: String, subtitle: String, teacher: String, classroom: String) {
        self.title.text = title
        self.subtitle.text = subtitle
        self.teacher.text = teacher
        self.classroom.text = classroom
        
        // time
        // nnumber of lesson
    }
}

private extension TrainingCellView {
    func setupViews() {
        setupView(stackView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)
        stackView.addArrangedSubview(teacher)
        stackView.addArrangedSubview(classroom)
    }

    func constaintViews() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
    }

    func configureAppearance() {
        backgroundColor = .white
    }
}

