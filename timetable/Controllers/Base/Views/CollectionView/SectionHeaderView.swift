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
        label.textColor = App.Colors.text_2
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
    func configure(with str: String, textSize size: CGFloat = 13) {
        self.title.text = str
        title.font = App.Fonts.helveticaNeue(with: size)
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
