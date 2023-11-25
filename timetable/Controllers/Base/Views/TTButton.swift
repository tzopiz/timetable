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
    private let label = TTLabel()
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
        addTarget(target, action: action, for: .touchUpInside)
    }
    /// set helveticaNeue font with size
    func setFontSize(_ size: CGFloat) {
        label.font = App.Fonts.helveticaNeue(with: size)
    }
    /// set tintcolor, label.tintColor and label.textColor
    func setTintColor(_ color: UIColor?) {
        tintColor = color
        label.tintColor = color
        label.textColor = color
    }
}

private extension TTButton {
    /// set up subview on button
    func setupViews() { setupView(label) }
    /// add constaraints to subviews
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
    /// configre appearence subviews
    func configureAppearance() {
        switch type {
        case .primary:
            setTintColor(R.color.title())
            label.font = App.Fonts.helveticaNeue(with: 22)
        case .secondary:
            label.textAlignment = .center
            layer.cornerRadius = 7
            setTintColor(R.color.active())
        }
        makeSystem(self)
    }
}
