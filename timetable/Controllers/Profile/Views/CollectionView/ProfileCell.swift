//
//  ProfileCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//

import UIKit

final class ProfileCell: UICollectionViewCell {
    
    static let reuseID = String(describing: ProfileCell.self)
    
    private var sizeImage: CGFloat = 32
    
    private let title = UILabel()
    private var subtitle = UILabel()
    private var leftView = UIImageView(image: App.Images.Profile.imageProfile?.withRenderingMode(.alwaysTemplate))
    private let stackInfoView = UIStackView()
    
    func configure(title: String, type: cellType, image: UIImage) {
        
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
    }
    func isHighlighted() {
        self.backgroundColor = App.Colors.secondary.withAlphaComponent(0.2)
    }
    func isUnHighlighted() {
        self.backgroundColor = App.Colors.BlackWhite
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
        
        self.backgroundColor = App.Colors.BlackWhite
        self.layer.cornerRadius = 20
        
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

