//
//  LabelTextView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.07.2023.
//

import UIKit

final class LabelTextView: TTBaseView {
    private let label = TTLabel(fontSize: 16)
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = App.Fonts.helveticaNeue(with: 14)
        textView.textColor = App.Colors.text
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 16
        return textView
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    func configure(title: String, text: String) {
        label.text = title
        textView.text = text
    }
}

extension LabelTextView {
    override func setupViews() {
        super.setupViews()
        setupView(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textView)
    }
    
    override func constraintViews() {
        super.constraintViews()
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
    }
}
