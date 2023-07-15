//
//  SceneDelegate.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.getUserInterfaceStyle()
        if !UserDefaults.standard.registered {
            let tabBarController = TabBarController()
            window?.rootViewController = tabBarController
        } else {
            let authVC = AuthorizationController()
            let navVc = NavigationController(rootViewController: authVC)
            window?.rootViewController = navVc
        }
        window?.makeKeyAndVisible()
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

