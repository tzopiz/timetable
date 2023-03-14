//
//  TasksCellView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

enum CellRoundedType {
    case top, bottom, all, notRounded
}
final class TasksCell: UICollectionViewCell {
    
    var borderLayer = CAShapeLayer()
    
    static let reuseID =  String(describing: TasksCell.self)
    
    private let checkmarkView = UIImageView(image: App.Images.Overview.checkmarkNotDone)
    private let stackView = UIStackView()
    private let title = UILabel()
    private let subtitle = UILabel()
    
    private var separator = UIView()

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
    
    override var isSelected: Bool {
        didSet {
            // TODO: open TaskViewController
        }
    }

    func configure(with title: String, subtitle: String, isDone: Bool, roundedType: CellRoundedType) {
        
        self.title.text = title
        self.subtitle.text = subtitle
        
        checkmarkView.image = isDone ? App.Images.Overview.checkmarkDone : App.Images.Overview.checkmarkNotDone
        
        switch roundedType {
        case .all:
            roundCorners(with: &borderLayer, [.allCorners], radius: 20)
            separator.isHidden = true
        case .bottom:
            roundCorners(with: &borderLayer, [.bottomLeft, .bottomRight], radius: 20)
            separator.isHidden = true
        case .top:
            roundCorners(with: &borderLayer, [.topLeft, .topRight], radius: 20)
            separator.isHidden = false
            addBottomBorder(separator: &separator, with: App.Colors.separator, height: 1)
        case .notRounded:
            roundCorners(with: &borderLayer, [.allCorners], radius: 0)
            separator.isHidden = false
            addBottomBorder(separator: &separator, with: App.Colors.separator, height: 1)
        }
        
    }
    
}

private extension TasksCell {
    func setupViews() {
        
        layer.addSublayer(borderLayer)
        setupView(separator)
        setupView(checkmarkView)
        setupView(stackView)
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)

    }

    func constaintViews() {
        NSLayoutConstraint.activate([
            
            checkmarkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            checkmarkView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkView.heightAnchor.constraint(equalToConstant: 28),
            checkmarkView.widthAnchor.constraint(equalTo: checkmarkView.heightAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: checkmarkView.trailingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
        ])
    }

    func configureAppearance() {
        
        self.backgroundColor = UIColor.clear
        borderLayer.fillColor = App.Colors.BlackWhite.cgColor
        
        stackView.axis = .vertical
        stackView.spacing = 3
        
        title.font = App.Fonts.helveticaNeue(with: 17)
        title.textColor = App.Colors.title
        
        subtitle.font = App.Fonts.helveticaNeue(with: 13)
        subtitle.textColor = App.Colors.inactive
        
    }
    @objc func handleTap(){
        print(#function)
    }
}

