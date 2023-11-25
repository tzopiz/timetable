//
//  NavigationController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
// timetable

import UIKit

final class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.blackWhite()
        navigationBar.isTranslucent = false
        guard let titleColor = R.color.title() else { return }
        navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: R.font.robotoRegular(size: 17)!
        ]
    }
}
