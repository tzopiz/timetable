//
//  ContentView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 09.03.2023.
//

import UIKit

final class ContentView: TTBaseView {
    
    private let importanceLabel = TTLabel(text: "Важность: ", fontSize: 17)
    private let deadlineLabel = TTLabel(text: "Дедлайн: ", fontSize: 17)
    private let nameTaskField: UITextField = {
        let textField = UITextField()
        textField.font = App.Fonts.helveticaNeue(with: 17)
        textField.textColor = App.Colors.title
        textField.placeholder = App.Strings.newTask
        textField.backgroundColor = App.Colors.BlackWhite
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    private let taskInfoView: UITextView = {
        let textView = UITextView()
        textView.font = App.Fonts.helveticaNeue(with: 17)
        textView.textColor = App.Colors.title
        textView.text = ""
        textView.backgroundColor = App.Colors.BlackWhite
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        return textView
    }()
    private let settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    private let importanceTask: TTBaseView = {
        let view = TTBaseView()
        view.backgroundColor = App.Colors.BlackWhite
        view.layer.cornerRadius = 10
        return view
    }()
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [UIImage(),
                                                 App.Images.exclamation_1,
                                                 App.Images.exclamation_2,
                                                 App.Images.exclamation_3])
        control.setTitleTextAttributes([.foregroundColor: App.Colors.red], for: .normal)
        return control
    }()
    private let deadlineTask: TTBaseView = {
        let view = TTBaseView()
        view.backgroundColor = App.Colors.BlackWhite
        view.layer.cornerRadius = 10
        return view
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        let oneYearTime: TimeInterval = 365 * 24 * 60 * 60
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        picker.maximumDate = Date().addingTimeInterval(4 * oneYearTime)
        return picker
    }()
    private let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = App.Colors.active
        return switcher
    }()
    private var isDone = false
    private var importance: Bool = false
    private var needCreate: Bool?
    private var deadline: Date?
    
    func configure(label: String,
                   name: String? = "",
                   info: String? = "",
                   isDone: Bool = false,
                   importance: Bool = false,
                   deadline: Date? = nil,
                   needCreate: Bool = false) {
        self.nameTaskField.text = name
        self.taskInfoView.text = info
        self.isDone = isDone
        self.needCreate = needCreate
        self.importance = importance
        self.segmentedControl.selectedSegmentIndex = Int(importance ? 0 : 1)
        
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
    
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) { importance = (Int16(sender.selectedSegmentIndex) != 0) }
    @IBAction func datePickerChange(parametr: UIDatePicker) { deadline = parametr.date }
    @IBAction func deadlineHandler(_ sender: UISwitch) {
        if sender.isOn {
            TTBaseView.animate(
                withDuration: 0.4, animations: {
                    self.datePicker.transform = .identity
                    self.datePicker.alpha = 1
                }, completion: { _ in
                    self.deadline = Date()
                    self.datePicker.date = self.deadline!
                })
        } else {
            TTBaseView.animate(
                withDuration: 0.4, animations: {
                    self.datePicker.alpha = 0
                    self.datePicker.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { _ in
                    self.deadline = nil
                    self.datePicker.date = Date()
                })
        }
    }
}

extension ContentView {
    override func setupViews() {
        setupView(mainStackView)
        
        settingsStackView.addArrangedSubview(importanceTask)
        settingsStackView.addArrangedSubview(deadlineTask)
        
        importanceTask.addSubview(segmentedControl)
        importanceTask.addSubview(importanceLabel)
        
        deadlineTask.addSubview(deadlineLabel)
        deadlineTask.addSubview(datePicker)
        deadlineTask.addSubview(switcher)
        
        mainStackView.addArrangedSubview(nameTaskField)
        mainStackView.addArrangedSubview(taskInfoView)
        mainStackView.addArrangedSubview(settingsStackView)
    }
    override func constraintViews() {
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
        
    }
    override func configureAppearance() {
        self.backgroundColor = App.Colors.background
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChange), for: .valueChanged)
        switcher.addTarget(self, action: #selector(deadlineHandler), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(datePickerChange(parametr:)), for: .valueChanged)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        addGestureRecognizer(tap)
    }
}
