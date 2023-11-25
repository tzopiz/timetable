//
//  TTButton.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

public class TTButton: UIButton {
    enum TTButtonType {
        case primary
        case secondary
    }

    private var type: TTButtonType = .primary
    private let label = TTLabel()
    init(with type: TTButtonType) {
        super.init(frame: .zero)
        self.type = type
        setupViews()
        layoutViews()
        configureViews()
    }
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupViews()
        layoutViews()
        configureViews()
    }
    func setTitle(_ title: String?) {
        self.label.text = title
    }
    func addButtonTarget(target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    /// set helveticaNeue font with size
    func setFontSize(_ size: CGFloat) {
        self.label.font = R.font.robotoRegular(size: size)!
    }
    /// set tintcolor, label.tintColor and label.textColor
    func setTintColor(_ color: UIColor?) {
        self.tintColor = color
        self.label.tintColor = color
        self.label.textColor = color
    }
}

private extension TTButton {
    /// set up subview on button
    func setupViews() { setupView(label) }
    /// add constaraints to subviews
    func layoutViews() {
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
    func configureViews() {
        switch type {
        case .primary:
            setTintColor(R.color.title())
            label.font = R.font.robotoRegular(size: 22)
        case .secondary:
            label.textAlignment = .center
            layer.cornerRadius = 7
            setTintColor(R.color.active())
        }
        makeSystem(self)
    }
}
