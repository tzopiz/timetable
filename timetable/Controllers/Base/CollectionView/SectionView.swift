//
//  SectionView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit
import SnapKit

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
    func setupViews() { addSubview(title) }
    /// add constaraints to subviews
    func constaintViews() {
        title.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.center.equalToSuperview()
        }
    }
    /// configre appearence subviews
    func configureAppearance() {}
}
