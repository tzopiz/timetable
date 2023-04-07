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

    func configure(time: String, nameSubject: String, address: String, teacherName: String) {
        self.time.text = time
        if self.time.text == "" {
            clock.image = nil
            self.nameSubject.textAlignment = .center
        } else {
            clock.image = App.Images.clock
            self.nameSubject.textAlignment = .left

        }
        self.nameSubject.text = nameSubject
        self.address.text = address
        self.teacherName.text = teacherName
    }
}

private extension TimetableCell {
    func setupViews() {
        setupView(stackView)
        setupView(firstLineView)
        firstLineView.addArrangedSubview(clock)
        firstLineView.addArrangedSubview(time)
        
        stackView.addArrangedSubview(firstLineView)
        stackView.addArrangedSubview(nameSubject)
        stackView.addArrangedSubview(address)
        stackView.addArrangedSubview(teacherName)
    }

    func constaintViews() {
        stackView.anchor(left: leadingAnchor, paddingLeft: 16,
                         right: trailingAnchor, paddingRight: -16,
                         centerY: centerYAnchor)
        clock.setDimensions(height: 16, width: 16)
    }

    func configureAppearance() {
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 20
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        firstLineView.axis = .horizontal
        firstLineView.spacing = 5
        
        nameSubject.font = App.Fonts.helveticaNeue(with: 17)
        nameSubject.textColor = App.Colors.title
        nameSubject.numberOfLines = 2
        
        address.font = App.Fonts.helveticaNeue(with: 13)
        address.textColor = App.Colors.inactive
        address.numberOfLines = 2
        
        teacherName.font = App.Fonts.helveticaNeue(with: 13)
        teacherName.textColor = App.Colors.inactive
        teacherName.numberOfLines = 2
        
        time.font = App.Fonts.helveticaNeue(with: 15)
        time.textColor = App.Colors.title
        time.numberOfLines = 2
    }
}
