//
//  TabBarController.swift
//  WorkoutApp
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit


final class TabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        configureAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAppearance()
    }

    func switchTo(tab: Tabs) {
        selectedIndex = tab.rawValue
    }

    private func configureAppearance() {
        tabBar.tintColor = App.Colors.active
        tabBar.barTintColor = App.Colors.inactive
        tabBar.backgroundColor = .white
        tabBar.layer.borderColor = App.Colors.separator.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.layer.masksToBounds = true

        let controllers: [NavBarController] = Tabs.allCases.map { tab in
            let controller = NavBarController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: App.Strings.TabBar.title(for: tab),
                                                 image: App.Images.TabBar.icon(for: tab),
                                                 tag: tab.rawValue)
            return controller
        }

        setViewControllers(controllers, animated: false)
    }

    private func getController(for tab: Tabs) -> TTBaseController {
        switch tab {
        case .overview: return OverviewController()
        case .tasks:    return  SessionController()
        case .peoples: return ProgressController()
        case .profile: return SettingsController()
        }
    }
}
