//
//  XAxisView.swift
//  WorkoutApp
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class YAxisView: TTBaseView {

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        return view
    }()

    func configure(with data: [TTChartsView.Data]) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        (0...9).reversed().forEach {
            let lable = UILabel()
            lable.font = App.Fonts.menloRegular(with: 9)
            lable.textColor = App.Colors.inactive
            lable.textAlignment = .right
            lable.text = "\($0 * 10)" // TODO: - Remake to colculated interval

            stackView.addArrangedSubview(lable)
        }
    }
}

extension YAxisView {
    override func setupViews() {
        super.setupViews()

        setupView(stackView)
    }

    override func constaintViews() {
        super.constaintViews()

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    override func configureAppearance() {
        super.configureAppearance()

        backgroundColor = .clear
    }
}


