//
//  SettingsCellView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//

import UIKit

final class SettingsCellView: UICollectionViewCell {
    
    static let reuseID = String(describing: SettingsCellView.self)
    static let nib = UINib(nibName: String(describing: SettingsCellView.self), bundle: nil)
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.menloRegular(with: 17)
        label.textColor = App.Colors.titleGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private var subtitle: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.menloRegular(with: 15)
        label.textColor = App.Colors.inactive
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var photoProfile: UIImageView = {
        let imageView = UIImageView(image: App.Images.Profile.imageProfile?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = App.Colors.inactive
        return imageView
    }()
    
    private let stackInfoView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    func configure(title: String,type: cellType,  image: UIImage, roundedType: CellRoundedType) {
        
        if type == .profile {
            self.subtitle.text = "21.Б04"
            stackInfoView.axis = .vertical
            photoProfile.tintColor = App.Colors.separator
            photoProfile.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            stackInfoView.addArrangedSubview(subtitle)
            sizeImage = -1
        } else {
            photoProfile.tintColor = App.Colors.active
            photoProfile.heightAnchor.constraint(equalToConstant: sizeImage).isActive = true

        }
        self.title.text = title
        self.photoProfile.image = image
        switch roundedType {
        case .all: self.roundCorners([.allCorners], radius: 5)
        case .bottom: self.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        case .top: self.roundCorners([.topLeft, .topRight], radius: 5)
        case .notRounded: self.roundCorners([.allCorners], radius: 0)
        }
    }
    private var sizeImage: CGFloat = 32
    

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
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 4
    }
    
}

private extension SettingsCellView {
    func setupViews() {
        setupView(stackInfoView)
        setupView(photoProfile)
        
        stackInfoView.addArrangedSubview(title)
        

    }

    func constaintViews() {
        
        NSLayoutConstraint.activate([

            photoProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            photoProfile.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoProfile.widthAnchor.constraint(equalTo: photoProfile.heightAnchor),
            
            stackInfoView.leadingAnchor.constraint(equalTo: photoProfile.trailingAnchor, constant: 16),
            stackInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackInfoView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configureAppearance() {
        backgroundColor = .white
    }
    
}

