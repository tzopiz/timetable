//
//  WeekdayView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit
import SnapKit

extension WeekView {
    final class WeekdayView: TTBaseView {
        private let index: Int
        private let nameLabel = TTLabel(fontSize: 9, textAlignment: .center)
        private let dateLabel = TTLabel(textAlignment: .center)
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.spacing = 3
            stackView.axis = .vertical
            return stackView
        }()
        
        private var normalColor: UIColor?
        private var tappedColor: UIColor?
        
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
            let isToday = currenrDay.stripTime([.year, .month, .day]) == Date().stripTime([.year, .month, .day,])

            normalColor = isToday ? R.color.active() : R.color.background()
            tappedColor = R.color.commonButtonTappedColor()
            
            backgroundColor = normalColor
            
            nameLabel.text = name.uppercased()
            nameLabel.textColor = isToday ? .white : R.color.subtitle()

            dateLabel.text = "\(day)"
            dateLabel.textColor = isToday ? .white : R.color.subtitle()
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
        addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dateLabel)
    }
    override func layoutViews() {
        stackView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    override func configureViews() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        addTapGesture(tapNumber: 1, target: self, action: #selector(handleTap))
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.05
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
