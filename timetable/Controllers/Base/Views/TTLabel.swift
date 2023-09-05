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
/// textColor = App.Colors.text
/// font = App.Fonts.helveticaNeue(with: 15)
/// ```
public class TTLabel: UILabel {
    init(text: String = "",
         textColor: UIColor = App.Colors.title,
         fontSize: CGFloat = 15,
         textAlignment: NSTextAlignment = .left,
         lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.lineBreakMode = lineBreakMode
        self.textColor = textColor
        self.font = App.Fonts.helveticaNeue(with: fontSize)
        self.text = text
        self.numberOfLines = 0
        setupViews()
        constraintViews()
        configureAppearance()
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
    func constraintViews() {
        // Добавьте код для установки ограничений для подвидов,
        // таких как установка автолейаут-ограничений, задание отступов и т.д.
    }
    
    /// Настраивает внешний вид представления.
    func configureAppearance() {
        // Добавьте код для настройки внешнего вида представления,
        // таких как установка фона, цветов, шрифтов и других свойств визуальных элементов.
        // Вы также можете применять стили, добавлять тени, закруглять углы и т.д.
    }
}
