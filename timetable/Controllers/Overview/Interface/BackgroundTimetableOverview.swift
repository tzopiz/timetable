//
//  BackgroundTimetableOverview.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 16.07.2023.
//

import UIKit
import SnapKit

final class BackgroundTimetableOverview: TTBaseView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let title = TTLabel(textColor: R.color.subtitle(), fontSize: 20, textAlignment: .center)
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    func updateImage() {
        let lessonsCanceledLight = [R.image.background1Light(),R.image.background2Light(),
                                    R.image.background3Light(),R.image.background4Light(),
                                    R.image.background5Light(),R.image.background6Light()]
        let lessonsCanceledDark = [R.image.background1Dark(), R.image.background2Dark()]
        switch UserDefaults.standard.theme {
        case .light, .device: imageView.image = lessonsCanceledLight.randomElement()!
        case .dark: imageView.image = lessonsCanceledDark.randomElement()!
        }
    }
    func configure(height: CGFloat, width: CGFloat) {
        imageView.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.width.equalTo(width)
        }
    }
}

extension BackgroundTimetableOverview {
    override func setupViews() {
        super.setupViews()
        addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(title)
    }
    override func layoutViews() {
        super.layoutViews()
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }      
    }
    override func configureViews() {
        super.configureViews()
        title.text = "На этой недели пар нет.\nСамое время отдохнуть!"
    }
}
