//
//  TaskInfoView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.10.2023.
//

import UIKit

class TaskInfoView: TTBaseView {
    private let nameTaskField: UITextField = {
        let textField = UITextField()
        textField.font = App.Fonts.HelveticaNeueBold(with: 21)
        textField.textColor = App.Colors.title
        textField.placeholder = App.Strings.newTask
        textField.backgroundColor = App.Colors.background
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    private let taskInfoView: UITextView = {
        let textView = UITextView()
        textView.font = App.Fonts.helveticaNeue(with: 16)
        textView.textColor = App.Colors.title
        textView.backgroundColor = App.Colors.background
        return textView
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    func configure(name: String, info: String) {
        self.nameTaskField.text = name
        self.taskInfoView.text = info
    }
}

extension TaskInfoView {
    override func setupViews() {
        
        setupView(stackView)
        
        stackView.addArrangedSubview(nameTaskField)
        stackView.addArrangedSubview(taskInfoView)
    }
    override func constraintViews() {
        stackView.anchor(top: topAnchor, bottom: bottomAnchor,
                         left: leadingAnchor, paddingLeft: 0,
                         right: trailingAnchor, paddingRight: -0)
        nameTaskField.setDimensions(height: 50)
        
    }
    override func configureAppearance() {
    }
}