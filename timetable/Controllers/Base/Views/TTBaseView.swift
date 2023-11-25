//
//  TTBaseView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

public class TTBaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
        configureViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        layoutViews()
        configureViews()
    }
}

@objc
extension TTBaseView {
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
