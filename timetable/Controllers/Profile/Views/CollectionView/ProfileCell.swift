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
    let button = UIButton(type: .system)
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
                setupView(button)
                let title = UserDefaults.standard.theme.getUserInterfaceStyle() == .dark ? "Темная": UserDefaults.standard.theme.getUserInterfaceStyle() == .light ? "Светлая" : "Системная"
                button.setTitle(title, for: .normal)
                button.titleLabel?.font = App.Fonts.helveticaNeue(with: 18)
                button.addTarget(self, action: #selector(showAlertController), for: .touchUpInside)
                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: 40),
                    button.centerYAnchor.constraint(equalTo: centerYAnchor),
                    button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
                ])
                
            } else {
                leftView.tintColor = App.Colors.active
            }
        }
    }
    @objc func showAlertController() {
        showInputDialog(firstTitle: "Светлое",
                        secondTitle: "Темное",
                        thirdTitle: "Системное",
                        cancelTitle: "Отмена")
    }
    func isHighlighted() { self.backgroundColor = App.Colors.secondary.withAlphaComponent(0.4) }
    func isUnHighlighted() { self.backgroundColor = App.Colors.BlackWhite }
    func showInputDialog(firstTitle:String, secondTitle:String, thirdTitle:String, cancelTitle:String)  {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        let viewController = window?.rootViewController
        func updateData() {
            window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.getUserInterfaceStyle()
            let title = UserDefaults.standard.theme.getUserInterfaceStyle() == .dark ? "Темное": UserDefaults.standard.theme.getUserInterfaceStyle() == .light ? "Светлое" : "Системное"
            self.button.setTitle(title, for: .normal)
        }
        alert.addAction(UIAlertAction(title: firstTitle, style: .default,  handler: { (action:UIAlertAction) in
            UserDefaults.standard.theme = .light
            updateData()
        }))
        alert.addAction(UIAlertAction(title: secondTitle, style: .default, handler: { (action:UIAlertAction) in
            UserDefaults.standard.theme = .dark
            updateData()
        }))
        alert.addAction(UIAlertAction(title: thirdTitle, style: .default,  handler: { (action:UIAlertAction) in
            UserDefaults.standard.theme = .device
            updateData()
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        
        viewController?.present(alert, animated: true, completion: nil)
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
