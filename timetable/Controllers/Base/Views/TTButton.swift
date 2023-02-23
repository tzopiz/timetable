//
//  TTButton.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

public enum TTButtonType {
    case primary
    case secondary
}

final class TTButton: UIButton {

    var type: TTButtonType = .primary

    private let lable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        return lable
    }()

    init(with type: TTButtonType) {
        super.init(frame: .zero)
        self.type = type

        setupViews()
        constaintViews()
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)

        setupViews()
        constaintViews()
        configureAppearance()
    }

    func setTitle(_ title: String?) {
        lable.text = title
    }
}

private extension TTButton {

    func setupViews() {
        setupView(lable)
    }

    func constaintViews() {
        var horisontalOffset: CGFloat {
            switch type {
            case .primary: return 0
            case .secondary: return 10
            }
        }

        NSLayoutConstraint.activate([
            lable.centerYAnchor.constraint(equalTo: centerYAnchor),
            lable.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -10),
            lable.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

    func configureAppearance() {
        switch type {
        case .primary:
            lable.textColor = App.Colors.inactive
            lable.font = App.Fonts.menloRegular(with: 13)

        case .secondary:
            backgroundColor = App.Colors.secondary
            layer.cornerRadius = 14
            lable.textColor = App.Colors.active
            lable.font = App.Fonts.menloRegular(with: 15)
        }

        makeSystem(self)
    }
}
