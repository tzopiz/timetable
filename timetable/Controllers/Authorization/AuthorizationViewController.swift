//
//  AuthorizationViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 06.04.2023.
//

import UIKit

class AuthorizationViewController: TTBaseController {
    
    private let containerView = SelectCategoryView()
    
}

// MARK: - Configure

extension AuthorizationViewController {
    override func setupViews() {
        super.setupViews()
        view.setupView(containerView)
    }
    override func constraintViews() {
        super.constraintViews()
        containerView.anchor(left: view.leadingAnchor, paddingLeft: 32,
                             right: view.trailingAnchor, paddingRight: -32,
                             centerY: view.safeAreaLayoutGuide.centerYAnchor)
        
    }
    override func configureAppearance() {
        super.configureAppearance()
        
        containerView.completion = {
            let tabvc = TabBarController()
            let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScenes?.windows.first?.switchRootViewController(tabvc)
        }
    }
}
