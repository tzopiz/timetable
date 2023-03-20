//
//  TabBarController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

enum Tabs: Int, CaseIterable {
    case overview
    case tasks
    case people
    case profile
}

final class TabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureAppearance()
    }

    func switchTo(tab: Tabs) { selectedIndex = tab.rawValue }

    private func configureAppearance() {
        tabBar.tintColor = App.Colors.active
        tabBar.barTintColor = App.Colors.separator
        tabBar.backgroundColor = UIColor.clear
        tabBar.layer.borderColor = App.Colors.BlackWhite.cgColor
        tabBar.addTopBorder(with: .black, height: 2/3)
        
        tabBar.createCustomBackgroundView(with: 0, shadowOfSet: 0)

        let controllers: [NavigationController] = Tabs.allCases.map { tab in
            let controller = NavigationController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: nil,
                                                 image: App.Images.icon(for: tab),
                                                 tag: tab.rawValue)
            controller.navigationBar.isHidden = true
            return controller
        }
        setViewControllers(controllers, animated: false)
    }

    private func getController(for tab: Tabs) -> TTBaseController {
        switch tab {
        case .overview: return OverviewController()
        case .tasks:    return TasksController()
        case .people:   return PeopleViewController()
        case .profile:  return ProfileController()
        }
    }
}
