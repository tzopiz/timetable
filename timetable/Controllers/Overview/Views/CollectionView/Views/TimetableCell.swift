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
    
    private let title = UILabel()
    private let subtitle = UILabel()
    private let teacherNS = UILabel()
    private let time = UILabel()
    
    private let clock = UIImageView(image: App.Images.Timetable.clock)
    
    var borderLayer = CAShapeLayer()

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

    func configure(with title: String, subtitle: String, teacherNS: String, time: String) {
        
        self.title.text = title
        self.subtitle.text = subtitle
        self.teacherNS.text = teacherNS
        self.time.text = time
        
    }
}

private extension TimetableCell {
    func setupViews() {
        
        setupView(stackView)
        setupView(firstLineView)
        
        firstLineView.addArrangedSubview(clock)
        firstLineView.addArrangedSubview(time)
        
        stackView.addArrangedSubview(firstLineView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)
        stackView.addArrangedSubview(teacherNS)
        
    }

    func constaintViews() {
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            clock.widthAnchor.constraint(equalToConstant: 16),
            clock.heightAnchor.constraint(equalToConstant: 16)
            
        ])
    }

    func configureAppearance() {
        
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 20
        
        stackView.axis = .vertical
        stackView.spacing = 5
        
        firstLineView.axis = .horizontal
        firstLineView.spacing = 5
        
        title.font = App.Fonts.helveticaNeue(with: 17)
        title.textColor = App.Colors.title
        title.numberOfLines = 2
  
        subtitle.font = App.Fonts.helveticaNeue(with: 13)
        subtitle.textColor = App.Colors.inactive
        subtitle.numberOfLines = 2
      
        teacherNS.font = App.Fonts.helveticaNeue(with: 13)
        teacherNS.textColor = App.Colors.inactive
        teacherNS.numberOfLines = 2
      
        time.font = App.Fonts.helveticaNeue(with: 15)
        time.textColor = App.Colors.title
        time.numberOfLines = 2
        
    }
}

