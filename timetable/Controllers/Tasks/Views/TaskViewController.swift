//
//  TaskViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 08.03.2023.
//

import UIKit


final class TaskViewController: TTBaseController {
    
    private let contentView = ContentView()
    
    private let buttonSave: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = App.Fonts.helveticaNeue(with: 20)
        button.backgroundColor = App.Colors.secondary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 9
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Новая задача"
        label.font = App.Fonts.helveticaNeue(with: 17)
        label.textColor = App.Colors.titleGray
        label.textAlignment = .center
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
extension TaskViewController {
    override func setupViews() {
        
        view.setupView(stackView)
        view.setupView(contentView)
        view.setupView(buttonSave)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(contentView)


    }
    override func constraintViews() {
        
        NSLayoutConstraint.activate([
            
            buttonSave.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonSave.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonSave.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: buttonSave.topAnchor)

        ])
        
    }
    override func configureAppearance() {
        super.configureAppearance()
        
        buttonSave.addTarget(self, action: #selector(addButtonSave), for: .touchUpInside)
        
    }
    @objc func addButtonSave() {
        
        // TODO: create new task
      
    }
}
