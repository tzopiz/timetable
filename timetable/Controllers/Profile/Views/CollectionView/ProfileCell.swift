//
//  ProfileCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//

import UIKit

final class ProfileCell: UICollectionViewCell {
    
    static let reuseID = String(describing: ProfileCell.self)
    
    var borderLayer = CAShapeLayer()
    private var sizeImage: CGFloat = 32
    
    private let title = UILabel()
    private var subtitle = UILabel()
    private var leftView = UIImageView(image: App.Images.Profile.imageProfile?.withRenderingMode(.alwaysTemplate))
    private let stackInfoView = UIStackView()
    
    func configure(title: String, type: cellType, image: UIImage, roundedType: CellRoundedType) {
        
        if type == .profile {
            self.subtitle.text = "21.Б04"
            stackInfoView.axis = .vertical
            stackInfoView.spacing = 10
            leftView.tintColor = App.Colors.separator
            leftView.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
            stackInfoView.addArrangedSubview(subtitle)
            sizeImage = -1
        } else if type == .exit{
            leftView.tintColor = UIColor.red
            leftView.heightAnchor.constraint(equalToConstant: sizeImage).isActive = true
        } else {
            leftView.tintColor = App.Colors.active
            leftView.heightAnchor.constraint(equalToConstant: sizeImage).isActive = true

        }
        self.title.text = title
        self.leftView.image = image
        switch roundedType {
        case .all: self.roundCorners(with: &borderLayer, [.allCorners], radius: 20)
        case .bottom: self.roundCorners(with: &borderLayer, [.bottomLeft, .bottomRight], radius: 20)
        case .top: self.roundCorners(with: &borderLayer, [.topLeft, .topRight], radius: 20)
        case .notRounded: self.roundCorners(with: &borderLayer, [.allCorners], radius: 0)
        }
    }
  
    

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
    
}

private extension ProfileCell {
    func setupViews() {
        
        layer.addSublayer(borderLayer)
        
        setupView(stackInfoView)
        setupView(leftView)
        
        stackInfoView.addArrangedSubview(title)
        
    }

    func constaintViews() {
        
        NSLayoutConstraint.activate([

            leftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            leftView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftView.widthAnchor.constraint(equalTo: leftView.heightAnchor),
            
            stackInfoView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 16),
            stackInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackInfoView.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
    }

    func configureAppearance() {
        self.backgroundColor = UIColor.clear
        self.borderLayer.fillColor = App.Colors.BlackWhite.cgColor
        
        title.font = App.Fonts.helveticaNeue(with: 17)
        title.textColor = App.Colors.title
        title.textAlignment = .left
        title.numberOfLines = 0
        
        subtitle.font = App.Fonts.helveticaNeue(with: 15)
        subtitle.textColor = App.Colors.inactive
        subtitle.textAlignment = .left
        subtitle.numberOfLines = 0
        
        leftView.tintColor = App.Colors.inactive
        
        stackInfoView.spacing = 2
        stackInfoView.axis = .horizontal
        stackInfoView.distribution = .fillEqually
        
    }
    
}

