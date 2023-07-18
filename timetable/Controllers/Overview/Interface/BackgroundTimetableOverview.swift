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
    private let title = TTLabel(textColor: App.Colors.text_2, fontSize: 20, textAlignment: .center)
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
    func configure(height: CGFloat, width: CGFloat) {
        imageView.setDimensions(height: height, width: width)
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
      
    }
    override func configureAppearance() {
        super.configureAppearance()
        title.text = "На этой недели пар нет.\nСамое время отдохнуть!"
    }
}
