//
//  TimetableCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.02.2023.
//

import UIKit

final class TimetableCell: BaseCell {
    
    override class var reuseIdentifier: String { return String(describing: TimetableCell.self) }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    private let firstLineView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    private let time = TTLabel()
    private let nameSubject = TTLabel(fontSize: 17)
    private let address = TTLabel(textColor: App.Colors.subtitle, fontSize: 13)
    private let teacherName = TTLabel(textColor: App.Colors.subtitle, fontSize: 13)
    private let clock = UIImageView(image: App.Images.clock)

    func configure(time: String, nameSubject: String, location: String, teacherName: String, isCancelled: Bool) {
        if isCancelled { // bolt
            let attributedTimeString = NSAttributedString(string: time, attributes: [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue,
                NSAttributedString.Key.strikethroughColor: App.Colors.red
            ])
            let attributedNameString = NSAttributedString(string: nameSubject, attributes: [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue,
                NSAttributedString.Key.strikethroughColor: App.Colors.red
            ])
            let attributedLocationString = NSAttributedString(string: location, attributes: [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue,
                NSAttributedString.Key.strikethroughColor: App.Colors.red
            ])
            let attributedTeacherString = NSAttributedString(string: teacherName, attributes: [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue,
                NSAttributedString.Key.strikethroughColor: App.Colors.red
            ])
            
            self.time.attributedText = attributedTimeString
            self.nameSubject.attributedText = attributedNameString
            self.address.attributedText = attributedLocationString
            self.teacherName.attributedText = attributedTeacherString
        } else {
            let attributedTimeString = NSAttributedString(string: time)
            let attributedNameString = NSAttributedString(string: nameSubject)
            let attributedLocationString = NSAttributedString(string: location)
            let attributedTeacherString = NSAttributedString(string: teacherName)
            
            self.time.attributedText = attributedTimeString
            self.nameSubject.attributedText = attributedNameString
            self.address.attributedText = attributedLocationString
            self.teacherName.attributedText = attributedTeacherString
        }
    }
}

extension TimetableCell {
    override func setupViews() {
        contentView.setupView(stackView)
        setupView(firstLineView)
        
        firstLineView.addArrangedSubview(clock)
        firstLineView.addArrangedSubview(time)
        
        stackView.addArrangedSubview(firstLineView)
        stackView.addArrangedSubview(nameSubject)
        stackView.addArrangedSubview(address)
        stackView.addArrangedSubview(teacherName)
    }
    override func constraintViews() {
        stackView.anchor(top: contentView.topAnchor, paddingTop: 8,
                         bottom: contentView.bottomAnchor, paddingBottom: -8,
                         left: contentView.leadingAnchor, paddingLeft: 16,
                         right: contentView.trailingAnchor, paddingRight: -16)
        self.contentView.setDimensions(width: bounds.width)
        self.contentView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor)
        clock.setDimensions(height: 16, width: 16)
    }
    override func configureAppearance() {
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 16
    }
}
