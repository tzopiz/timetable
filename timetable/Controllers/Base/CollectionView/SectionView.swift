//
//  SectionView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class SectionView: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: SectionView.self)
    
    private let title = TTLabel(textColor: R.color.subtitle(), fontSize: 13, textAlignment: .center)

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
        title.font = R.font.robotoRegular(size: size)!
    }
}

private extension SectionView {
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
