//
//  TrainingCellView.swift
//  timtable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class TrainingCellView: UICollectionViewCell {
    
    static let id = "TrainingCellView"

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 7
        return view
    }()
    private let firstLine: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        return view
    }()
    
    private let numberLesson: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.menloRegular(with: 14)
        label.textColor = App.Colors.active
        return label
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.menloRegular(with: 14)
        label.textColor = App.Colors.inactive
        return label
    }()
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.menloRegular(with: 17)
        label.textColor = App.Colors.titleGray
        return label
    }()
    private let teacher: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.menloRegular(with: 14)
        label.textColor = App.Colors.inactive
       
        return label
    }()
    private let classroom: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.menloRegular(with: 14)
        label.textColor = App.Colors.inactive
        label.numberOfLines = 0
        return label
    }()
    private let fon: TTBaseView = {
        let view = TTBaseView(frame: .zero)
        view.alpha = 0.5
        return view
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

    func configure(with title: String, subtitle: String, teacher: String, classroom: String, number lesson: Int) {
        self.subtitle.text = subtitle
        self.teacher.text = teacher
        self.classroom.text = classroom
        self.title.text = title
        self.numberLesson.text = "\(lesson)"
        let startOfWeek = Date().startOfWeek
        let currenrDay = startOfWeek.agoForward(to: lesson - 1) // ? +
        let isCurrentLesson = currenrDay.stripTime(.Day) == Date().stripTime(.Day)
        
        switch isCurrentLesson { // TODO: highlighting current lesson
        case true:
            self.numberLesson.textColor = App.Colors.background
            self.fon.backgroundColor = App.Colors.active
            self.fon.alpha = 1
        case false:
            self.numberLesson.textColor = App.Colors.inactive
            self.fon.alpha = 0
            
        }
    }
}

private extension TrainingCellView {
    func setupViews() {
        setupView(fon)
        setupView(stackView)
        setupView(firstLine)
        firstLine.addArrangedSubview(numberLesson)
        firstLine.addArrangedSubview(title)
        stackView.addArrangedSubview(firstLine)
        stackView.addArrangedSubview(subtitle)
        stackView.addArrangedSubview(teacher)
        stackView.addArrangedSubview(classroom)
    }

    func constaintViews() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
//            fon.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            fon.leadingAnchor.constraint(equalTo: leadingAnchor),
            fon.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            fon.heightAnchor.constraint(equalToConstant: 20),
            fon.widthAnchor.constraint(equalToConstant: 40),
            title.leadingAnchor.constraint(equalTo: fon.trailingAnchor, constant: 7),
            
            firstLine.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            firstLine.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
      
        ])
    }

    func configureAppearance() {
        backgroundColor = .white
    }

}

