//
//  UIView + ext.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

extension UIView {
    func addBottomBorder(separator: inout UIView, with color: UIColor, height: CGFloat) {
        separator.backgroundColor = color
        separator.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth]
        separator.frame = CGRect(x: 0, y: frame.height - height, width: frame.width, height: height)
    }
    func addBottomBorder(with color: UIColor, height: CGFloat) {
        let separator = UIView()
        separator.backgroundColor = color
        separator.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth]
        separator.frame = CGRect(x: 0, y: frame.height - height, width: frame.width, height: height)
        addSubview(separator)
    }
    func addTopBorder(separator: inout UIView, with color: UIColor, height: CGFloat) {
        separator.backgroundColor = color
        separator.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth]
        separator.frame = CGRect(x: 0, y: 0, width: frame.width, height: height)
        
    }
    func addTopBorder(with color: UIColor, height: CGFloat) {
        let separator = UIView()
        separator.backgroundColor = color
        separator.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth]
        separator.frame = CGRect(x: 0, y: 0, width: frame.width, height: height)
        addSubview(separator)
    }

    func makeSystem(_ button: UIButton) {
        button.addTarget(self, action: #selector(handleIn), for: [
            .touchDown,
            .touchDragInside
        ])

        button.addTarget(self, action: #selector(handleOut), for: [
            .touchDragOutside,
            .touchUpInside,
            .touchUpOutside,
            .touchDragExit,
            .touchCancel
        ])
    }

    @objc func handleIn() {
        UIView.animate(withDuration: 0.15) { self.alpha = 0.55 }
    }

    @objc func handleOut() {
        UIView.animate(withDuration: 0.15) { self.alpha = 1 }
    }

    @objc func setupView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    func roundCorners(with borderLayer: inout CAShapeLayer,  _ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        borderLayer.frame = bounds
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1
    }
    
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}
