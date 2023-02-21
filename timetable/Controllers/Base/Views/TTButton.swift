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

    private var type: TTButtonType = .primary

    private let lable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        return lable
    }()

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = App.Images.Common.downArrow?.withRenderingMode(.alwaysTemplate)
        return view
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
        setupView(iconView)
    }

    func constaintViews() {
        var horisontalOffset: CGFloat {
            switch type {
            case .primary: return 0
            case .secondary: return 10
            }
        }

        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horisontalOffset),
            iconView.heightAnchor.constraint(equalToConstant: 5),
            iconView.widthAnchor.constraint(equalToConstant: 10),

            lable.centerYAnchor.constraint(equalTo: centerYAnchor),
            lable.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -10),
            lable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horisontalOffset * 2)
        ])
    }

    func configureAppearance() {
        switch type {
        case .primary:
            lable.textColor = App.Colors.inactive
            lable.font = App.Fonts.menloRegular(with: 13)
            iconView.tintColor = App.Colors.inactive

        case .secondary:
            backgroundColor = App.Colors.secondary
            layer.cornerRadius = 14
            lable.textColor = App.Colors.active
            lable.font = App.Fonts.menloRegular(with: 15)
            iconView.tintColor = App.Colors.active
        }

        makeSystem(self)
    }
}
