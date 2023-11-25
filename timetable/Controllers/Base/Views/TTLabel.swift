//
//  TTLabel.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 18.07.2023.
//

import UIKit

/// ```
/// numberOfLines = 0
/// textAlignment = .left
/// lineBreakMode = .byWordWrapping
/// textColor = R.color.title
/// font = R.font.robotoRegular(size: 15)
/// ```
public class TTLabel: UILabel {
    init(text: String = "",
         textColor: UIColor? = R.color.title(),
         fontSize: CGFloat = 15,
         textAlignment: NSTextAlignment = .left,
         lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.lineBreakMode = lineBreakMode
        self.textColor = textColor
        self.font = R.font.robotoRegular(size: fontSize)
        self.text = text
        self.numberOfLines = 0
        setupViews()
        layoutViews()
        configureViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

@objc
extension TTLabel {
    /// Добавляет подвиды на представление.
    func setupViews() {
        // Добавьте код для добавления подвидов на представление,
        // таких как их инициализация, настройка свойств и добавление на представление.
    }
    
    /// Устанавливает ограничения для подвидов внутри представления.
    func layoutViews() {
        // Добавьте код для установки ограничений для подвидов,
        // таких как установка автолейаут-ограничений, задание отступов и т.д.
    }
    
    /// Настраивает внешний вид представления.
    func configureViews() {
        // Добавьте код для настройки внешнего вида представления,
        // таких как установка фона, цветов, шрифтов и других свойств визуальных элементов.
        // Вы также можете применять стили, добавлять тени, закруглять углы и т.д.
    }
}
