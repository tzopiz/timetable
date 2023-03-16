//
//  ProfileCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//

import UIKit

enum CellType {
    case base
    case profile
    case exit
    case theme
}

final class ProfileCell: UICollectionViewCell {
    static let reuseID = String(describing: ProfileCell.self)
    private let title = UILabel()
    private var subtitle = UILabel()
    private var leftView = UIImageView(image: App.Images.imageProfile.withRenderingMode(.alwaysTemplate))
    private let stackInfoView = UIStackView()
    private var segmentedControl: UISegmentedControl!
    func configure(title: String, type: CellType, image: UIImage) {
        self.title.text = title
        self.leftView.image = image
        if type == .profile {
            self.subtitle.text = "21.Б04"
            stackInfoView.axis = .vertical
            stackInfoView.spacing = 10
            stackInfoView.addArrangedSubview(subtitle)
            leftView.heightAnchor.constraint(equalToConstant: 88).isActive = true
            leftView.widthAnchor.constraint(equalToConstant: 88).isActive = true
        } else {
            leftView.heightAnchor.constraint(equalToConstant: 32).isActive = true
            leftView.widthAnchor.constraint(equalToConstant: 32).isActive = true
            if type == .exit {
                leftView.tintColor = UIColor.red
            } else if type == .theme {
                segmentedControl = UISegmentedControl(items: ["Light", "Dark", "System"])
                setupView(segmentedControl)
                segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
                segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                segmentedControl.selectedSegmentIndex =  UserDefaults.standard.theme.getUserInterfaceStyle() == .light ? 0 :  UserDefaults.standard.theme.getUserInterfaceStyle() == .dark ? 1 : 2
                segmentedControl.backgroundColor = UIColor.clear
                
            } else {
                leftView.tintColor = App.Colors.active
            }
        }
    }
    func addTargetSegmentedControl(target: Any?, action: Selector) {
        segmentedControl.addTarget(action, action: action, for: .valueChanged)
    }
    func isHighlighted() {
        self.backgroundColor = App.Colors.secondary.withAlphaComponent(0.4)
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
            
            stackInfoView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 16),
            stackInfoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackInfoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            title.heightAnchor.constraint(equalToConstant: 40)
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
        
        stackInfoView.spacing = 2
        stackInfoView.axis = .horizontal
        stackInfoView.distribution = .fillEqually
    }
}
