//
//  TaskViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 08.03.2023.
//

import UIKit

final class TaskViewController: TTBaseController {
    private let contentView = ContentView()
    private let separator = TTBaseView()
    private let buttonDelete = UIButton(type: .system)
    private let buttonSave = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    init(taskName: String? = nil, textInfo: String = "", isDone: Bool = false, needToCreate: Bool) {
        super.init(nibName: nil, bundle: nil)
        if let title = taskName {
            contentView.configure(label: isDone ? "Выполненная задача": "Активная задача",
                                  nameTask: title, text: textInfo)
        } else {
            contentView.configure(label: "Новая задача", nameTask: "", text: textInfo)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TaskViewController {
    override func setupViews() {
        view.setupView(contentView)
        view.setupView(buttonStackView)
        buttonStackView.addArrangedSubview(buttonDelete)
        buttonStackView.addArrangedSubview(separator)
        buttonStackView.addArrangedSubview(buttonSave)

    }
    override func constraintViews() {
        buttonStackView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: -16,
                               left: view.leadingAnchor, paddingLeft: 16,
                               right: view.trailingAnchor, paddingRight: -16)
        contentView.anchor(top: view.topAnchor, paddingTop: 16,
                           bottom: buttonStackView.topAnchor,
                           left: view.leadingAnchor,
                           right: view.trailingAnchor)
        separator.anchor(centerX: view.centerXAnchor,
                         height: buttonStackView.heightAnchor)
        separator.setDimensions(width: 16)
    }
    override func configureAppearance() {
        super.configureAppearance()
        self.view.backgroundColor = App.Colors.background
        self.view.tintColor = App.Colors.active
       
        buttonSave.layer.cornerRadius = 10
        buttonDelete.tintColor = App.Colors.active
        buttonSave.setTitle("Сохранить", for: .normal)
        buttonSave.backgroundColor = App.Colors.BlackWhite
        buttonSave.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        buttonSave.addTarget(self, action: #selector(addButtonSave), for: .touchUpInside)
        
        buttonDelete.layer.cornerRadius = 10
        buttonDelete.tintColor = App.Colors.red
        buttonDelete.setTitle("Удалить", for: .normal)
        buttonDelete.backgroundColor = App.Colors.BlackWhite
        buttonDelete.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        buttonDelete.addTarget(self, action: #selector(addButtonDelete), for: .touchUpInside)
        
        buttonStackView.axis = .horizontal
        
        separator.backgroundColor = .clear
    }
    @objc func addButtonSave() {
        self.dismiss(animated: true)
        // TODO: save task
    }
    @objc func addButtonDelete() {
        self.dismiss(animated: true)
        // TODO: delete task
    }
}
