//
//  TopTitleView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 09.03.2023.
//

import UIKit

final class ContentView: TTBaseView {
    private let label = UILabel()
    private let nameTaskField = UITextField()
    private let taskInfoView = UITextView()
    private let mainStackView = UIStackView()

    func configure(label: String, nameTask: String, text: String) {
        self.label.text = label
        self.nameTaskField.text = nameTask
        self.taskInfoView.text = text
    }
}

extension ContentView {
    override func setupViews() {
        super.setupViews()
        setupView(mainStackView)
        mainStackView.addArrangedSubview(label)
        mainStackView.addArrangedSubview(nameTaskField)
        mainStackView.addArrangedSubview(taskInfoView)
    }

    override func constraintViews() {
        super.constraintViews()
        label.anchor(centerX: centerXAnchor)
        nameTaskField.setDimensions(height: 50)
        mainStackView.anchor(top: topAnchor,
                             bottom: bottomAnchor, paddingBottom: -16,
                             left: leadingAnchor, paddingLeft: 16,
                             right: trailingAnchor, paddingRight: -16)
        
    }

    override func configureAppearance() {
        super.configureAppearance()
        self.backgroundColor = App.Colors.background
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        label.font = App.Fonts.helveticaNeue(with: 17)
        label.textColor = App.Colors.title
        label.textAlignment = .center
        
        nameTaskField.font = App.Fonts.helveticaNeue(with: 17)
        nameTaskField.textColor = App.Colors.title
        nameTaskField.placeholder = "Новая задача"
        nameTaskField.backgroundColor = App.Colors.BlackWhite
        nameTaskField.layer.cornerRadius = 10
        nameTaskField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTaskField.frame.height))
        nameTaskField.leftViewMode = .always
        
        taskInfoView.font = App.Fonts.helveticaNeue(with: 17)
        taskInfoView.textColor = App.Colors.title
        taskInfoView.text = ""
        taskInfoView.backgroundColor = App.Colors.BlackWhite
        taskInfoView.layer.cornerRadius = 10
        taskInfoView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
}
