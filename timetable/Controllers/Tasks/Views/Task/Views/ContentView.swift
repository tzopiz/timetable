//
//  TopTitleView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 09.03.2023.
//

import UIKit

final class ContentView: TTBaseView {
    
    private let label = UILabel()
    private let nameTask = UITextField()
    private let textView = UITextView()
    private let mainStackView = UIStackView()

    func configure(label: String, nameTask: String, text: String){
        self.label.text = label
        self.nameTask.text = nameTask
        self.textView.text = text
     
    }
    
}

extension ContentView {
    override func setupViews() {
        super.setupViews()
        
        setupView(mainStackView)

        mainStackView.addArrangedSubview(label)
        mainStackView.addArrangedSubview(nameTask)
        mainStackView.addArrangedSubview(textView)
        
    }

    override func constraintViews() {
        super.constraintViews()
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        nameTask.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            nameTask.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
    }

    override func configureAppearance() {
        super.configureAppearance()
        
        backgroundColor = App.Colors.background
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        
        label.font = App.Fonts.helveticaNeue(with: 17)
        label.textColor = App.Colors.titleGray
        label.textAlignment = .center
        
        nameTask.font = App.Fonts.helveticaNeue(with: 17)
        nameTask.textColor = App.Colors.titleGray
        nameTask.placeholder = "Новая задача"
        nameTask.backgroundColor = .white
        nameTask.translatesAutoresizingMaskIntoConstraints = false
        nameTask.layer.cornerRadius = 10
        nameTask.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTask.frame.height))
        nameTask.leftViewMode = .always
        
        textView.font = App.Fonts.helveticaNeue(with: 17)
        textView.textColor = App.Colors.titleGray
        textView.text = ""
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
    }
}
