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
            contentView.configure(label: isDone ? "Выполненная задача": "Активная задача", nameTask: title, text: textInfo)
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
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor),
            
            separator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separator.widthAnchor.constraint(equalToConstant: 16),
            separator.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor)

        ])
        
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        
        buttonSave.addTarget(self, action: #selector(addButtonSave), for: .touchUpInside)
        buttonDelete.addTarget(self, action: #selector(addButtonDelete), for: .touchUpInside)
        
        buttonSave.setTitle("Сохранить", for: .normal)
        buttonSave.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        buttonSave.backgroundColor = .white
        buttonSave.layer.cornerRadius = 10
        
        buttonDelete.setTitle("Удалить", for: .normal)
        buttonDelete.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        buttonDelete.backgroundColor = .white
        buttonDelete.tintColor = .red
        buttonDelete.layer.cornerRadius = 10
        
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
