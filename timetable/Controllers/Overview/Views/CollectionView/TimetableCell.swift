//
//  TimetableCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.02.2023.
//

import UIKit

final class TimetableCell: UICollectionViewCell {
    
    static let reuseID =  String(describing: TimetableCell.self)
    private let stackView = UIStackView()
    private let firstLineView = UIStackView()
    private let time = UILabel()
    private let nameSubject = UILabel()
    private let address = UILabel()
    private let teacherName = UILabel()
    private let clock = UIImageView()
    private var borderLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
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

    func configure(time: String, nameSubject: String, location: String, teacherName: String, isCancelled: Bool) {
        if time == "" { // TODO: нормально показывать, что пар нет
            clock.image = nil
            self.nameSubject.textAlignment = .center
        } else {
            clock.image = App.Images.clock
            self.nameSubject.textAlignment = .left
        }
        if isCancelled {
            let attributedTimeString = NSAttributedString(string: time,
                                                      attributes: [
                                                        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                        NSAttributedString.Key.strikethroughColor: App.Colors.red // Замените на желаемый цвет
                                                      ])
            let attributedNameString = NSAttributedString(string: nameSubject,
                                                      attributes: [
                                                        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                        NSAttributedString.Key.strikethroughColor: App.Colors.red // Замените на желаемый цвет
                                                      ])
            let attributedLocationString = NSAttributedString(string: location,
                                                      attributes: [
                                                        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                        NSAttributedString.Key.strikethroughColor: App.Colors.red // Замените на желаемый цвет
                                                      ])
            let attributedTeacherString = NSAttributedString(string: teacherName,
                                                      attributes: [
                                                        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                        NSAttributedString.Key.strikethroughColor: App.Colors.red // Замените на желаемый цвет
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

private extension TimetableCell {
    func setupViews() {
        contentView.setupView(stackView)
        setupView(firstLineView)
        
        firstLineView.addArrangedSubview(clock)
        firstLineView.addArrangedSubview(time)
        
        stackView.addArrangedSubview(firstLineView)
        stackView.addArrangedSubview(nameSubject)
        stackView.addArrangedSubview(address)
        stackView.addArrangedSubview(teacherName)
    }

    func constaintViews() {
        stackView.anchor(top: contentView.topAnchor, paddingTop: 8,
                             bottom: contentView.bottomAnchor, paddingBottom: -8,
                             left: contentView.leadingAnchor, paddingLeft: 16,
                             right: contentView.trailingAnchor, paddingRight: -16)

        self.contentView.setDimensions(width: bounds.width)
        self.contentView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor)
        clock.setDimensions(height: 16, width: 16)
    }

    func configureAppearance() {
        
        nameSubject.preferredMaxLayoutWidth = contentView.bounds.width - 32
        
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 20
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        firstLineView.axis = .horizontal
        firstLineView.spacing = 5
        
        time.font = App.Fonts.helveticaNeue(with: 15)
        time.textColor = App.Colors.title
        time.numberOfLines = 0
        time.lineBreakMode = .byWordWrapping
        
        nameSubject.font = App.Fonts.helveticaNeue(with: 17)
        nameSubject.textColor = App.Colors.title
        nameSubject.numberOfLines = 0
        nameSubject.lineBreakMode = .byWordWrapping
        
        address.font = App.Fonts.helveticaNeue(with: 13)
        address.textColor = App.Colors.inactive
        address.numberOfLines = 0
        address.lineBreakMode = .byWordWrapping
        
        teacherName.font = App.Fonts.helveticaNeue(with: 13)
        teacherName.textColor = App.Colors.inactive
        teacherName.numberOfLines = 0
        teacherName.lineBreakMode = .byWordWrapping
    }
}
