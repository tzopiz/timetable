//
//  TabBarController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

enum Tabs: Int, CaseIterable {
    case tasks
    case overview
    case profile
}

final class TabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureAppearance()
        CoreDataMamanager.shared.saveProfileImage()
        switchTo(tab: .tasks)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func switchTo(tab: Tabs) { selectedIndex = tab.rawValue }

    private func configureAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = App.Colors.active
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = App.Colors.BlackWhite
        // tabBar.layer.borderColor = App.Colors.BlackWhite.cgColor
        tabBar.addTopBorder(with: App.Colors.separator, height: 1/2)

        let controllers: [NavigationController] = Tabs.allCases.map { tab in
            let controller = NavigationController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: nil,
                                                 image: App.Images.icon(for: tab),
                                                 tag: tab.rawValue)
            return controller
        }
        setViewControllers(controllers, animated: false)
    }
    private func getController(for tab: Tabs) -> TTBaseController {
        switch tab {
        case .overview: return OverviewController()
        case .tasks:    return TasksController()
        case .profile:  return ProfileController()
        }
    }
}
