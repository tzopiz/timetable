//
//  TTBaseInfoView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

class TTBaseInfoView: TTBaseView {

    private let titleLabel = UILabel()
    private let button = TTButton(with: .primary)
    private let contentView = UIView()

    init(with title: String? = nil, buttonTitle: String? = nil) {
        
        titleLabel.text = title?.uppercased()
        titleLabel.textAlignment = buttonTitle == nil ? .center : .left

        button.setTitle(buttonTitle?.uppercased())
        button.isHidden = buttonTitle == nil ? true : false
        
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
    func addButtonTarget(target: Any?, action: Selector) {
        button.addTarget(action, action: action, for: .touchUpInside)
    }
}

extension TTBaseInfoView {
    override func setupViews() {
        super.setupViews()

        setupView(titleLabel)
        setupView(button)
        setupView(contentView)
    }

    override func constraintViews() {
        super.constraintViews()

        let contentTopAnchor: NSLayoutAnchor = titleLabel.text == nil ? topAnchor : titleLabel.bottomAnchor
        let contentTopOffset: CGFloat = titleLabel.text == nil ? 0 : 10

        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 28),

            contentView.topAnchor.constraint(equalTo: contentTopAnchor, constant: contentTopOffset),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }

    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = .clear
        
        titleLabel.font = App.Fonts.helveticaNeue(with: 13)
        titleLabel.textColor = App.Colors.inactive
        
        contentView.backgroundColor = .white
        contentView.layer.borderColor = App.Colors.separator.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
        
       
    }
}
