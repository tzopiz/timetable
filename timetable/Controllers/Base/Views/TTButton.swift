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
    private let label = UILabel()
    private let iconView = UIImageView(image: App.Images.downArrow.withRenderingMode(.alwaysTemplate))
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
        label.text = title
    }
    func addButtonTarget(target: Any?, action: Selector) {
        addTarget(action, action: action, for: .touchUpInside)
    }
}

private extension TTButton {
    func setupViews() {
        setupView(label)
    }

    func constaintViews() {
        var horisontalOffset: CGFloat {
            switch type {
            case .primary: return 0
            case .secondary: return 10
            }
        }
        label.anchor(left: leadingAnchor, paddingLeft: 10,
                     right: trailingAnchor, paddingRight: -10,
                     centerY: centerYAnchor)
    }

    func configureAppearance() {
       
        switch type {
        case .primary:
            label.textAlignment = .left
            label.textColor = App.Colors.title
            label.font = App.Fonts.helveticaNeue(with: 22)
        case .secondary:
            label.textAlignment = .center
            backgroundColor = App.Colors.secondary
            layer.cornerRadius = 7
            label.textColor = App.Colors.active
            label.font = App.Fonts.helveticaNeue(with: 15)
            iconView.tintColor = App.Colors.active
        }
        makeSystem(self)
    }
}
