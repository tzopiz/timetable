//
//  CustomTransitionAnimator.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 09.10.2023.
//

import Foundation
import UIKit

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    // Реализуйте методы протокола UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // Укажите длительность анимации
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Получите контейнерный view, в котором происходит анимация
        let containerView = transitionContext.containerView
        
        // Получите ссылку на `toViewController`
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        // Установите начальное положение `toViewController` за пределами нижней грани экрана
        let screenHeight = containerView.bounds.height
        toViewController.view.frame = CGRect(x: 0, y: screenHeight, width: containerView.bounds.width, height: screenHeight)
        
        // Добавьте `toViewController` на контейнерный view
        containerView.addSubview(toViewController.view)
        
        // Анимация: перемещение `toViewController` вверх на экран
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.frame = CGRect(x: 0, y: screenHeight / 2, width: containerView.bounds.width, height: screenHeight / 2)
        }) { (_) in
            // Завершение анимации и сообщение о завершении контексту анимации
            transitionContext.completeTransition(true)
        }
    }

}
