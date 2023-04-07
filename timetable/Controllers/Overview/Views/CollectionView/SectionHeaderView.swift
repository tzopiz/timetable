//
//  SectionHeaderView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    static let id = String(describing: SectionHeaderView.self)
    private let title =  UILabel()
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
    func configure(with date: String) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE, dd MMMM"
//
//        self.title.text = dateFormatter.string(from: date).uppercased()
        self.title.text = date
    }
}

private extension SectionHeaderView {
    func setupViews() {
        setupView(title)
    }

    func constaintViews() {
        title.anchor(centerY: centerYAnchor, centerX: centerXAnchor)
    }
    func configureAppearance() {
        title.font = App.Fonts.helveticaNeue(with: 13)
        title.textColor = App.Colors.inactive
        title.textAlignment = .center
    }
}
