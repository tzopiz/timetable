//
//  BackgroundTimetableOverview.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 16.07.2023.
//

import UIKit

final class BackgroundTimetableOverview: TTBaseView {
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        return imageView
    }()
    private let title: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.helveticaNeue(with: 20)
        label.textAlignment = .center
        label.textColor = App.Colors.text_2
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    func updateImage() {
        switch UserDefaults.standard.theme {
        case .light, .device:
            imageView.image = App.Images.lessonsCanceled_light.randomElement()
        case .dark:
            imageView.image = App.Images.lessonsCanceled_dark.randomElement()
        }
    }
}

extension BackgroundTimetableOverview {
    override func setupViews() {
        super.setupViews()

        setupView(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(title)
    }
    override func constraintViews() {
        super.constraintViews()
        stackView.anchor(centerY: centerYAnchor, centerX: centerXAnchor)
        imageView.setDimensions(height: 300, width: 450)
    }
    override func configureAppearance() {
        super.configureAppearance()
        title.text = "На этой недели пар нет.\nСамое время отдохнуть!"
    }
}