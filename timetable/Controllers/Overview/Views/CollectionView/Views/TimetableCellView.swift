//
//  TimetableCellView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.02.2023.
//

import UIKit


final class TimetableCellView: UICollectionViewCell {
    
    static let id = "TimetableCellView"

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        return view
    }()
    
    private let firstLineView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 5
        return view
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.helveticaNeue(with: 17)
        label.textColor = App.Colors.titleGray
        label.numberOfLines = 2
        return label
    }()

    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.helveticaNeue(with: 13)
        label.textColor = App.Colors.inactive
        label.numberOfLines = 2
        return label
    }()
    
    private let teacherNS: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.helveticaNeue(with: 13)
        label.textColor = App.Colors.inactive
        label.numberOfLines = 2
        return label
    }()
    
    private let time: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.helveticaNeue(with: 15)
        label.textColor = App.Colors.titleGray
        label.numberOfLines = 2
        return label
    }()
    
    private let clock: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "clock"))
        return iv
    }()

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

    func configure(with title: String, subtitle: String, teacherNS: String, time: String, roundedType: CellRoundedType) {
        self.title.text = title
        self.subtitle.text = subtitle
        self.teacherNS.text = teacherNS
        self.time.text = time

        switch roundedType {
        case .all: self.roundCorners([.allCorners], radius: 5)
        case .bottom: self.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        case .top: self.roundCorners([.topLeft, .topRight], radius: 5)
        case .notRounded: self.roundCorners([.allCorners], radius: 0)
        }
    }
}

private extension TimetableCellView {
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
            
            clock.widthAnchor.constraint(equalToConstant: 17),
            clock.heightAnchor.constraint(equalToConstant: 17)
        ])
    }

    func configureAppearance() {
        backgroundColor = .white
    }
}

