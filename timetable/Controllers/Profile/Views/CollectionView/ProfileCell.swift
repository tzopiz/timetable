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
                let pickerView = UIPickerView()
                setupView(pickerView)
                pickerView.dataSource = self
                pickerView.delegate = self
                NSLayoutConstraint.activate([
                    pickerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
                    pickerView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    pickerView.heightAnchor.constraint(equalTo: heightAnchor),
                    pickerView.widthAnchor.constraint(equalToConstant: 150)
                ])
                pickerView.selectRow( UserDefaults.standard.theme.getUserInterfaceStyle() == .light ? 0 :  UserDefaults.standard.theme.getUserInterfaceStyle() == .dark ? 1 : 2, inComponent: 0, animated: true)
            } else {
                leftView.tintColor = App.Colors.active
            }
        }
    }
    func addTargetSegmentedControl(target: Any?, action: Selector) {
//        segmentedControl.addTarget(action, action: action, for: .valueChanged)
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

extension ProfileCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { 3 }
}

extension ProfileCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0: return "light"
        case 1: return "dark"
        case 2: return "system"
        default: return nil
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if #available(iOS 13.0, *) {
            switch row {
            case 0: UserDefaults.standard.theme = .light
            case 1: UserDefaults.standard.theme = .dark
            case 2: UserDefaults.standard.theme =  .device
            default: print("unexpected segment in " + #function)
            }
            let scenes = UIApplication.shared.connectedScenes
            let windowScenes = scenes.first as? UIWindowScene
            let window = windowScenes?.windows.first
            window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.getUserInterfaceStyle()
        }
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
