//
//  ScheduleNavigatorView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 08.08.2023.
//

import UIKit

class ScheduleNavigatorView: TTBaseView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    
    private let backButton: TTButton = {
        let button = TTButton(with: .secondary)
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "chevron.compact.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let titleLabelButton: TTButton = {
        let button = TTButton(with: .primary)
        button.setTitle("Сегодня")
        button.setFontSize(21)
        return button
    }()
    
    private let forwardButton: TTButton = {
        let button = TTButton(with: .secondary)
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "chevron.compact.right", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    var completionActionTo: ((WeekView.Directions) -> Void)?
    var titleAction: (() -> Void)?
    
    override func setupViews() {
        super.setupViews()
        addSubview(stackView)
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(titleLabelButton)
        stackView.addArrangedSubview(forwardButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        titleLabelButton.addTarget(self, action: #selector(titleButtonTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
    }
    
    override func constraintViews() {
        super.constraintViews()
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor)
    }
    
    @IBAction private func backButtonTapped() { completionActionTo?(.back) }
    @IBAction private func titleButtonTapped() { titleAction?() }
    @IBAction private func forwardButtonTapped() { completionActionTo?(.forward) }
}
