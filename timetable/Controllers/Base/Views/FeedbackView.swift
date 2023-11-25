//
//  FeedbackView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 18.07.2023.
//

import UIKit

final class FeedbackView: TTBaseView {
    
    private let vkButton: UIButton = createSocialMediaButton(App.Images.vk_icon, link: App.Strings.vk_link)
    private let githubButton: UIButton = createSocialMediaButton(App.Images.github_icon, link: App.Strings.github_link)
    private let tgButton: UIButton = createSocialMediaButton(App.Images.tg_icon, link: App.Strings.tg_link)
    private var stackView: UIStackView!
    
    private static func createSocialMediaButton(_ image: UIImage, link: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = R.color.active()
        button.addTarget(self, action: #selector(openLink(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = link
        return button
    }
    @objc private static func openLink(_ sender: UIButton) {
        guard let link = sender.accessibilityIdentifier,
              let encodedLink = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedLink) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension FeedbackView {
    override func setupViews() {
        super.setupViews()
        stackView = UIStackView(arrangedSubviews: [vkButton, githubButton, tgButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        setupView(stackView)
    }
    override func constraintViews() {
        super.constraintViews()
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor)
        vkButton.setDimensions(height: 20, width: 20)
        tgButton.setDimensions(height: 20, width: 20)
        githubButton.setDimensions(height: 20, width: 20)
    }
    override func configureAppearance() {
        super.configureAppearance()
    }
}
