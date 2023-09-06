//
//  WeekdayView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

extension WeekView {
    final class WeekdayView: TTBaseView {
        private let index: Int
        private let nameLabel = TTLabel(fontSize: 9, textAlignment: .center)
        private let dateLabel = TTLabel(textAlignment: .center)
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.spacing = 3
            stackView.axis = .vertical
            stackView.isUserInteractionEnabled = false
            return stackView
        }()
        
        private var normalColor = UIColor()
        private var tappedColor = UIColor()
        
        var scrollCompletion: ((Int) -> Void)?
        
        init(index: Int) {
            self.index = index
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with index: Int, name: String, shift: Int) {
            let startOfWeek = Date().startOfWeek
            let currenrDay = startOfWeek.agoForward(to: index + shift)
            let day = Date.calendar.component(.day, from: currenrDay)
            let isToday = currenrDay.stripTime(.toDays) == Date().stripTime(.toDays)

            backgroundColor = isToday ? App.Colors.active : App.Colors.background
            
            normalColor = isToday ? App.Colors.active : App.Colors.background
            tappedColor = App.Colors.commonButtonTappedColor
            
            nameLabel.text = name.uppercased()
            nameLabel.textColor = isToday ? .white : App.Colors.subtitle

            dateLabel.text = "\(day)"
            dateLabel.textColor = isToday ? .white : App.Colors.subtitle
        }
        static func getFirstDay(with index: Int) -> Date {
            let startOfWeek = Date().startOfWeek
            let currenrDay = startOfWeek.agoForward(to: 1 + index)
            return currenrDay
        }
    }
}

extension WeekView.WeekdayView {
    override func setupViews() {
        setupView(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dateLabel)
    }
    override func constraintViews() {
        stackView.anchor(centerY: centerYAnchor, centerX: centerXAnchor)
    }
    override func configureAppearance() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        
        tapGesture.numberOfTapsRequired = 1
        longPressGesture.minimumPressDuration = 0.05
        
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(longPressGesture)
        
    }
}
extension WeekView.WeekdayView {
    @IBAction private func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.2) { self.backgroundColor = self.normalColor }
        }
    }
    
    @IBAction private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began: UIView.animate(withDuration: 0.2) { self.backgroundColor = self.tappedColor }
        case .ended: UIView.animate(withDuration: 0.2) {
            self.backgroundColor = self.normalColor
            self.scrollCompletion?(self.index)
        }
        default: break
        }
    }
}
