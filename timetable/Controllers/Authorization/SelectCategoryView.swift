//
//  SelectCategoryVie.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 06.04.2023.
//

import UIKit

final class SelectCategoryView: TTBaseView {
    private let buttonStundet = TTButton(with: .secondary)
    private let buttonTeacher = TTButton(with: .secondary)
    private let stackView = UIStackView()
    var completion: (() -> ())?
}

// MARK: - Configure

extension SelectCategoryView {
    override func setupViews() {
        super.setupViews()
        addSubview(stackView)
        stackView.addArrangedSubview(buttonStundet)
        stackView.addArrangedSubview(buttonTeacher)
    }
    override func constraintViews() {
        super.constraintViews()
        stackView.anchor(top: topAnchor,
                         bottom: bottomAnchor,
                         left: leadingAnchor,
                         right: trailingAnchor)
        
        buttonStundet.setDimensions(height: 77)
        buttonTeacher.setDimensions(height: 77)

    }
    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = .clear
        stackView.axis = .vertical
        stackView.spacing = 32
        
        buttonStundet.setTitle("Student")
        buttonStundet.setFontSize(32)
        buttonStundet.setTintColor(App.Colors.active)
        buttonStundet.backgroundColor = App.Colors.secondary
        buttonStundet.layer.cornerRadius = 20
        buttonStundet.layer.borderWidth = 1
        buttonStundet.layer.borderColor = App.Colors.BlackWhite.cgColor
        buttonStundet.addButtonTarget(target: self, action:  #selector(buttonStudentHandler))
        
        buttonTeacher.setTitle("Teacher")
        buttonTeacher.setFontSize(32)
        buttonTeacher.setTintColor(App.Colors.active)
        buttonTeacher.backgroundColor = App.Colors.secondary
        buttonTeacher.layer.cornerRadius = 20
        buttonTeacher.layer.borderWidth = 1
        buttonTeacher.layer.borderColor = App.Colors.BlackWhite.cgColor
        buttonTeacher.addButtonTarget(target: self, action:  #selector(buttonTeacherHandler))
    }
}

// MARK: - Handlers

extension SelectCategoryView {
    @IBAction func buttonStudentHandler() {
        print(#function)
        completion?()
    }
    @IBAction func buttonTeacherHandler() {
        print(#function)
        completion?()
    }
}
