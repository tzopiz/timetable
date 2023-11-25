//
//  TimetableCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.02.2023.
//

import UIKit
import SnapKit

final class TimetableCell: BaseCell {
    
    override class var reuseIdentifier: String { return String(describing: TimetableCell.self) }
    // TODO: custom stackview with parametrs
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
    private let address = TTLabel(textColor: R.color.subtitle(), fontSize: 13)
    private let teacherName = TTLabel(textColor: R.color.subtitle(), fontSize: 13)
    private let clock = UIImageView(image: R.image.clock())
    func configure(_ lesson: Lesson) {
        var attributedTimeString: NSAttributedString
        var attributedNameString: NSAttributedString
        var attributedLocationString: NSAttributedString
        var attributedTeacherString: NSAttributedString
        if lesson.isCancelled { // bolt
            guard let red = R.color.red() else { return }
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue,
                NSAttributedString.Key.strikethroughColor: red
            ]
            attributedTimeString = NSAttributedString(string: lesson.time, attributes: attributes)
            attributedNameString = NSAttributedString(string: lesson.name, attributes: attributes)
            attributedLocationString = NSAttributedString(string: lesson.location, attributes: attributes)
            attributedTeacherString = NSAttributedString(string: lesson.teacher, attributes: attributes)
            
        } else {
            attributedTimeString = NSAttributedString(string: lesson.time)
            attributedNameString = NSAttributedString(string: lesson.name)
            attributedLocationString = NSAttributedString(string: lesson.location)
            attributedTeacherString = NSAttributedString(string: lesson.teacher)
        }
        self.time.attributedText = attributedTimeString
        self.nameSubject.attributedText = attributedNameString
        self.address.attributedText = attributedLocationString
        self.teacherName.attributedText = attributedTeacherString
    }
}

extension TimetableCell {
    override func setupViews() {
        contentView.addSubview(stackView)
        addSubview(firstLineView)
        
        firstLineView.addArrangedSubview(clock)
        firstLineView.addArrangedSubview(time)
        
        stackView.addArrangedSubview(firstLineView)
        stackView.addArrangedSubview(nameSubject)
        stackView.addArrangedSubview(address)
        stackView.addArrangedSubview(teacherName)
    }
    override func layoutViews() {
        contentView.snp.makeConstraints { make in
            make.width.equalTo(bounds.width)
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        clock.snp.makeConstraints { $0.height.width.equalTo(16) }
        
    }
    override func configureViews() {
        self.backgroundColor = R.color.blackWhite()
        self.layer.cornerRadius = 16
    }
}
