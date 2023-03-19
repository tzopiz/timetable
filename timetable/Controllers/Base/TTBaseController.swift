//
//  TTBaseController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

enum NavBarPosition {
    case left
    case right
}

class TTBaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constraintViews()
        configureAppearance()
    }
}

@objc extension TTBaseController {
    func setupViews() {}
    func constraintViews() {}
    func configureAppearance() { view.backgroundColor = App.Colors.background }
    func navBarLeftButtonHandler() { print("NavBar left button tapped") }
    func navBarRightButtonHandler() { print("NavBar right button tapped") }
}

extension TTBaseController {
    func addNavBarButton(at position: NavBarPosition, with title: String) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(App.Colors.active, for: .normal)
        button.setTitleColor(App.Colors.inactive, for: .disabled)
        button.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)

        switch position {
        case .left:
            button.addTarget(self, action: #selector(navBarLeftButtonHandler), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        case .right:
            button.addTarget(self, action: #selector(navBarRightButtonHandler), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
}
