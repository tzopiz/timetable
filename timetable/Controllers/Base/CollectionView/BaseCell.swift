//
//  SettingsCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit
import SnapKit

class BaseCell: UICollectionViewCell {
    
    class var reuseIdentifier: String { return String(describing: BaseCell.self) }
    
    public let title = TTLabel(fontSize: 17)
    public let stackInfoView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    func configure(title: String, backgroundColor color: UIColor? = nil,
                   textAlignment alignment: NSTextAlignment? = nil,
                   textSize size: CGFloat? = nil, cornerRadius: CGFloat = 16) {
        self.title.text = title
        if let color = color { self.backgroundColor = color }
        if let alignment = alignment { self.title.textAlignment = alignment }
        if let size = size { self.title.font = R.font.robotoRegular(size: size)! }
        self.layer.cornerRadius = cornerRadius
    }
    func isHighlighted() { self.alpha = 0.4 }
    func isUnHighlighted() { self.alpha = 1 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
        configureViews()
    }
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        setupViews()
        layoutViews()
        configureViews()
    }
}

@objc
extension BaseCell {
    /// set up subview on cell
    func setupViews() {
        contentView.addSubview(stackInfoView)
        stackInfoView.addArrangedSubview(title)
    }
    /// add constaraints to subviews
    func layoutViews() {
        stackInfoView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    /// configre appearence subviews
    func configureViews() {
        self.backgroundColor = R.color.blackWhite()
    }
}
