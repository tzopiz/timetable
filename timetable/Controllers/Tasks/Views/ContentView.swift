//
//  TopTitleView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 09.03.2023.
//

import UIKit

final class ContentView: TTBaseView {


    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nameTask: UITextField = {
        let view = UITextField()
        view.font = App.Fonts.helveticaNeue(with: 17)
        view.textColor = App.Colors.titleGray
        view.placeholder = "Новая задача"
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: view.frame.height))
        view.leftViewMode = .always
        return view
    }()
    private let textView: UITextView = {
        let view = UITextView()
        view.font = App.Fonts.helveticaNeue(with: 17)
        view.textColor = App.Colors.titleGray
        view.text = "more texta"
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return view
    }()
    
}

extension ContentView {
    override func setupViews() {
        super.setupViews()
        
        setupView(mainStackView)
 
        mainStackView.addArrangedSubview(nameTask)
        mainStackView.addArrangedSubview(textView)
        
    }

    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            nameTask.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
    }

    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = App.Colors.background
    }
}
