//
//  TopTitleView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 09.03.2023.
//

import UIKit

final class ContentView: TTBaseView {
    
    private let topLabel = UILabel()
    private let nameTaskField = UITextField()
    private let taskInfoView = UITextView()
   
    private let buttonSave = UIButton(type: .system)
    private let buttonDelete = UIButton(type: .system)
    
    private let buttonStackView = UIStackView()
    private let settingsStackView = UIStackView()
    private let mainStackView = UIStackView()
    
    private let importanceTask = TTBaseView()
    private let importanceLabel = UILabel()
    private let segmentedControl = UISegmentedControl(items: [UIImage(),
                                                              App.Images.exclamation_1,
                                                              App.Images.exclamation_2,
                                                              App.Images.exclamation_3])
    
    private let deadlineTask = TTBaseView()
    private let deadlineLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let switcher = UISwitch()
    
    private var isDone = false
    private var importance: Int16 = 0
    private var needCreate: Bool?
    private var deadline: Date?

    func configure(label: String,
                   taskName: String? = "",
                   text: String? = "",
                   isDone: Bool,
                   importance: Int16 = 0,
                   deadline: Date? = nil,
                   _ needCreate: Bool = false) {
        self.topLabel.text = label
        self.nameTaskField.text = taskName
        self.taskInfoView.text = text
        self.isDone = isDone
        self.needCreate = needCreate
        self.importance = importance
        self.segmentedControl.selectedSegmentIndex = Int(importance)
        
        self.datePicker.alpha = 0
        self.switcher.isOn = false
        if let deadline = deadline {
            self.deadline = deadline
            self.switcher.isOn = true
            self.datePicker.alpha = 1
            self.datePicker.date = deadline
        }
       
    }
    func getTaskInfo() -> [String: Any] {
        var task: [String: Any] = [:]
        task["taskName"] = nameTaskField.text
        task["taskInfo"] = taskInfoView.text
        task["isDone"] = isDone
        task["importance"] = importance
        task["needCreate"] = needCreate
        task["deadline"] = deadline
        return task
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
        deadlineTask.addSubview(switcher)
        
        mainStackView.addArrangedSubview(buttonStackView)
        mainStackView.addArrangedSubview(nameTaskField)
        mainStackView.addArrangedSubview(taskInfoView)
        mainStackView.addArrangedSubview(settingsStackView)
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
        switcher.anchor(right: deadlineTask.trailingAnchor, paddingRight: -16,
                        centerY: deadlineTask.centerYAnchor)
        datePicker.anchor(right: switcher.leadingAnchor, paddingRight: -16,
                          centerY: deadlineTask.centerYAnchor)
        
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
        topLabel.textColor = App.Colors.text
        topLabel.textAlignment = .center
        
        nameTaskField.font = App.Fonts.helveticaNeue(with: 17)
        nameTaskField.textColor = App.Colors.text
        nameTaskField.placeholder = "Новая задача"
        nameTaskField.backgroundColor = App.Colors.BlackWhite
        nameTaskField.layer.cornerRadius = 10
        nameTaskField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTaskField.frame.height))
        nameTaskField.leftViewMode = .always
        
        taskInfoView.font = App.Fonts.helveticaNeue(with: 17)
        taskInfoView.textColor = App.Colors.text
        taskInfoView.text = ""
        taskInfoView.backgroundColor = App.Colors.BlackWhite
        taskInfoView.layer.cornerRadius = 10
        taskInfoView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        buttonSave.tintColor = App.Colors.active
        buttonSave.setTitle("Сохранить", for: .normal)
        buttonSave.backgroundColor = UIColor.clear
        buttonSave.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        
        buttonDelete.tintColor = App.Colors.red
        buttonDelete.setTitle("Удалить", for: .normal)
        buttonDelete.backgroundColor = UIColor.clear
        buttonDelete.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        
        importanceTask.backgroundColor = App.Colors.BlackWhite
        importanceTask.layer.cornerRadius = 10
        
        importanceLabel.font = App.Fonts.helveticaNeue(with: 17)
        importanceLabel.textColor = App.Colors.text
        importanceLabel.textAlignment = .left
        importanceLabel.text = "Важность: "

        segmentedControl.setTitleTextAttributes([.foregroundColor: App.Colors.red], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChange), for: .valueChanged)
        
        deadlineTask.backgroundColor = App.Colors.BlackWhite
        deadlineTask.layer.cornerRadius = 10
        
        deadlineLabel.font = App.Fonts.helveticaNeue(with: 17)
        deadlineLabel.textColor = App.Colors.text
        deadlineLabel.textAlignment = .left
        deadlineLabel.text = "Deadline: "
        
        switcher.onTintColor = App.Colors.active
        switcher.addTarget(self, action: #selector(deadlineHandler), for: .valueChanged)
        
        let oneYearTime: TimeInterval = 365 * 24 * 60 * 60
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(4 * oneYearTime)
        datePicker.addTarget(self, action: #selector(datePickerChange(parametr:)), for: .valueChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        addGestureRecognizer(tap)
    }
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        importance = Int16(sender.selectedSegmentIndex)
    }
    @IBAction func datePickerChange(parametr: UIDatePicker) {
        deadline = parametr.date
    }
    @IBAction func deadlineHandler(_ sender: UISwitch) {
        if sender.isOn {
            TTBaseView.animate(
                withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                options: .curveEaseOut, animations: {
                    self.datePicker.transform = .identity
                    self.datePicker.alpha = 1
            }, completion: { _ in
                self.deadline = Date()
                self.datePicker.date = self.deadline!
            })
        } else {
            TTBaseView.animate(
                withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                options: .curveEaseOut, animations: {
                    self.datePicker.alpha = 0
                    self.datePicker.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { _ in
                    self.deadline = nil
                    self.datePicker.date = Date()
                })
        }
    }
    func addTargetButtonSave(target: Any?, action: Selector) {
        buttonSave.addTarget(action, action: action, for: .touchUpInside)
    }
    func addTargetButtonDelete(target: Any?, action: Selector) {
        buttonDelete.addTarget(action, action: action, for: .touchUpInside)
    }
}
