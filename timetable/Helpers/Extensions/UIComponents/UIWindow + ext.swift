//
//  UIWindow + ext.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 31.03.2023.
//

import UIKit

extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController { top = presented }
            else if let nav = top as? UINavigationController { top = nav.visibleViewController }
            else if let tab = top as? UITabBarController { top = tab.selectedViewController }
            else { break }
        }
        return top
    }
    func switchRootViewController(_ viewController: UIViewController,
                                  animated: Bool = true,
                                  duration: TimeInterval = 0.5,
                                  options: UIView.AnimationOptions = .transitionFlipFromRight,
                                  completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}
