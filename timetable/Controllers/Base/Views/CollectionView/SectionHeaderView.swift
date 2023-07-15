//
//  SectionHeaderView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: SectionHeaderView.self)
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = App.Fonts.helveticaNeue(with: 13)
        label.textColor = App.Colors.inactive
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
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
    func configure(with str: String, textSize size: CGFloat? = nil) {
        self.title.text = str
        if let size = size { title.font = App.Fonts.helveticaNeue(with: size) }
    }
}

private extension SectionHeaderView {
    /// set up subview on view
    func setupViews() { setupView(title) }
    /// add constaraints to subviews
    func constaintViews() {
        title.anchor(left: leadingAnchor, paddingLeft: 32,
                     right: trailingAnchor, paddingRight: -32,
                     centerY: centerYAnchor, centerX: centerXAnchor)
    }
    /// configre appearence subviews
    func configureAppearance() {}
}
