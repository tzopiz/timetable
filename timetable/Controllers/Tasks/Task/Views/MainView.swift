//
//  NavigationView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 06.10.2023.
//

import UIKit

final class MainView: TTBaseView {
    private let topLabel = TTLabel(fontSize: 21, textAlignment: .center)
    private let buttonSave: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = App.Colors.active
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        return button
    }()
    private let buttonDelete: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = App.Colors.red
        button.setTitle("Удалить", for: .normal)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        return button
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    private let taskInfoView = TaskInfoView()
    //    private let fieldsView (isImportant, isDone, deadline)
    
    weak var updateDelegate: UICollectionViewUpdatable?
    weak var actionDelegate: CustomViewActionDelegate?
    func configure(with task: Task?) {
        guard let task = task else { return }
        self.topLabel.text = "Задача"
        taskInfoView.configure(name: task.name, info: task.info)
    }
}

extension MainView {
    override func setupViews() {
        setupView(mainStackView)
        
        buttonStackView.addArrangedSubview(buttonDelete)
        buttonStackView.addArrangedSubview(topLabel)
        buttonStackView.addArrangedSubview(buttonSave)
        
        mainStackView.addArrangedSubview(buttonStackView)
        mainStackView.addArrangedSubview(taskInfoView)
        //        mainStackView.addArrangedSubview(fieldsView)
    }
    
    override func constraintViews() {
        topLabel.anchor(centerX: centerXAnchor)
        mainStackView.anchor(top: topAnchor, bottom: bottomAnchor,
                             left: leadingAnchor, right: trailingAnchor)
        buttonStackView.setDimensions(height: 30)
        
        buttonSave.setDimensions(width: 88)
        buttonDelete.setDimensions(width: 88)
    }
    
    override func configureAppearance() {
        buttonSave.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        buttonDelete.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
    }
}


extension MainView {
    @IBAction func saveTask() {
        actionDelegate?.didTapDismissButton {
            print(#function)
            self.updateDelegate?.updateCollectionView()
        }
    }
    @IBAction func deleteTask() {
//        CoreDataMamanager.shared.deletaAllTasks()
        actionDelegate?.didTapDismissButton {
            print(#function)
            self.updateDelegate?.updateCollectionView()
        }
    }
}