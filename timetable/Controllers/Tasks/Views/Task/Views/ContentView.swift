//
//  TopTitleView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 09.03.2023.
//

import UIKit

final class ContentView: TTBaseView {
    private let topLabel = UILabel()
    private let nameTaskField = UITextView()
    private let taskInfoView = UITextView()
    private let mainStackView = UIStackView()
    
    private let buttonSave = UIButton(type: .system)
    private let buttonDelete = UIButton(type: .system)
    private let buttonStackView = UIStackView()
    
    private let settingsStackView = UIStackView()
    
    // importance
    private let importanceTask = UIView()
    private let importanceLabel = UILabel()
    private let segmentedControl = UISegmentedControl(items:
                                                        [App.Strings.warning,
                                                         App.Strings.exclamation_1,
                                                         App.Strings.exclamation_2,
                                                         App.Strings.exclamation_3])
    
    // deadline
    private let deadlineTask = UIView()
    private let deadlineLabel = UILabel()
    private let datePicker = UIDatePicker()
    
    private let buttonComplete = UIButton(type: .system)

    func configure(label: String, nameTask: String, text: String, isDone: Bool) {
        self.topLabel.text = label
        self.nameTaskField.text = nameTask
        self.taskInfoView.text = text
        if isDone { self.buttonComplete.setTitle("Uncomplete", for: .normal) }
    }
}

extension ContentView {
    override func setupViews() {
        super.setupViews()
        setupView(mainStackView)
        
        buttonStackView.addArrangedSubview(buttonDelete)
        buttonStackView.addArrangedSubview(topLabel)
        buttonStackView.addArrangedSubview(buttonSave)
        
        settingsStackView.addArrangedSubview(importanceTask)
        settingsStackView.addArrangedSubview(deadlineTask)
        
        importanceTask.addSubview(segmentedControl)
        importanceTask.addSubview(importanceLabel)
        
        deadlineTask.addSubview(deadlineLabel)
        deadlineTask.addSubview(datePicker)
        
        mainStackView.addArrangedSubview(buttonStackView)
        mainStackView.addArrangedSubview(nameTaskField)
        mainStackView.addArrangedSubview(taskInfoView)
        mainStackView.addArrangedSubview(settingsStackView)
        mainStackView.addArrangedSubview(buttonComplete)
    }
    override func constraintViews() {
        super.constraintViews()
        topLabel.anchor(centerX: centerXAnchor)
        nameTaskField.setDimensions(height: 50)
        mainStackView.anchor(top: topAnchor, paddingTop: 16,
                             left: leadingAnchor, paddingLeft: 16,
                             right: trailingAnchor, paddingRight: -16)
        taskInfoView.setDimensions(height: 200)
        
        importanceTask.setDimensions(height: 50)
        segmentedControl.anchor(right: settingsStackView.trailingAnchor, paddingRight: -16,
                                centerY: importanceTask.centerYAnchor)
        segmentedControl.setDimensions(width: 200)
        importanceLabel.anchor(left: settingsStackView.leadingAnchor, paddingLeft: 16,
                               centerY: importanceTask.centerYAnchor)
        
        deadlineTask.setDimensions(height: 50)
        deadlineLabel.anchor(left: settingsStackView.leadingAnchor, paddingLeft: 16,
                               centerY: deadlineTask.centerYAnchor)
        datePicker.anchor(left: mainStackView.leadingAnchor,
                          right: settingsStackView.trailingAnchor, paddingRight: -16,
                          centerY: deadlineTask.centerYAnchor)
        datePicker.setDimensions(width: 200)
        
        buttonSave.setDimensions(width: 88)
        buttonDelete.setDimensions(width: 88)


    }
    override func configureAppearance() {
        super.configureAppearance()
        self.backgroundColor = App.Colors.background
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        settingsStackView.axis = .vertical
        settingsStackView.spacing = 16
        
        topLabel.font = App.Fonts.helveticaNeue(with: 17)
        topLabel.textColor = App.Colors.title
        topLabel.textAlignment = .center
        
        nameTaskField.font = App.Fonts.helveticaNeue(with: 17)
        nameTaskField.textColor = App.Colors.title
        nameTaskField.backgroundColor = .clear
        nameTaskField.layer.cornerRadius = 10
        nameTaskField.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 10, right: 5)
        nameTaskField.isScrollEnabled = false
        nameTaskField.textContainer.maximumNumberOfLines = 1
        nameTaskField.createCustomBackgroundView(with: 10, shadowOfSet: 0)
        
        taskInfoView.font = App.Fonts.helveticaNeue(with: 17)
        taskInfoView.backgroundColor = .clear
        taskInfoView.layer.cornerRadius = 10
        taskInfoView.textColor = App.Colors.title
        taskInfoView.text = ""
        taskInfoView.createCustomBackgroundView(with: 10, shadowOfSet: 0)
        taskInfoView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        buttonSave.tintColor = App.Colors.active
        buttonSave.setTitle("Сохранить", for: .normal)
        buttonSave.backgroundColor = UIColor.clear
        buttonSave.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        
        buttonDelete.tintColor = App.Colors.red
        buttonDelete.setTitle("Удалить", for: .normal)
        buttonDelete.backgroundColor = UIColor.clear
        buttonDelete.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        
        buttonComplete.layer.cornerRadius = 10
        buttonComplete.tintColor = App.Colors.active
        buttonComplete.setTitle("Выполнить", for: .normal)
        buttonComplete.backgroundColor = .clear
        buttonComplete.createCustomBackgroundView(with: 10, shadowOfSet: 0)
        buttonComplete.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        
        importanceTask.backgroundColor = .clear
        importanceTask.createCustomBackgroundView(with: 10, shadowOfSet: 0)
        importanceTask.layer.cornerRadius = 10
        
        importanceLabel.font = App.Fonts.helveticaNeue(with: 17)
        importanceLabel.textColor = App.Colors.title
        importanceLabel.textAlignment = .left
        importanceLabel.text = "Важность: "
        
        deadlineTask.backgroundColor = .clear
        deadlineTask.createCustomBackgroundView(with: 10, shadowOfSet: 0)
        deadlineTask.layer.cornerRadius = 10
        
        deadlineLabel.font = App.Fonts.helveticaNeue(with: 17)
        deadlineLabel.textColor = App.Colors.title
        deadlineLabel.textAlignment = .left
        deadlineLabel.text = "До: "
        
        datePicker.addTarget(self, action: #selector(datePickerChange(parametr:)), for: .valueChanged)
        datePicker.datePickerMode = .dateAndTime
        let oneYearTime: TimeInterval = 365 * 24 * 60 * 60
        datePicker.minimumDate = Date.now
        datePicker.maximumDate = Date().addingTimeInterval(2 * oneYearTime)
    }
    @objc func datePickerChange(parametr: UIDatePicker) {
        print(parametr.date.stripTime(.toDays))
        // TODO: get info
    }
    func addTargetButtonSave(target: Any?, action: Selector) {
        buttonSave.addTarget(action, action: action, for: .touchUpInside)
    }
    func addTargetButtonDelete(target: Any?, action: Selector) {
        buttonDelete.addTarget(action, action: action, for: .touchUpInside)
    }
    func addTargetButtonComplete(target: Any?, action: Selector) {
        buttonComplete.addTarget(action, action: action, for: .touchUpInside)
    }
}
