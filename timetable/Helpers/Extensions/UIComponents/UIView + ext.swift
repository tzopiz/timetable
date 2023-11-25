//
//  UIView + ext.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

extension UIView {
    func addBottomBorder(separator: inout UIView, with color: UIColor?, height: CGFloat) {
        guard let color = color else { return }
        separator.backgroundColor = color
        separator.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth]
        separator.frame = CGRect(x: 0, y: frame.height - height, width: frame.width, height: height)
    }
    func addTopBorder(separator: inout UIView, with color: UIColor?, height: CGFloat) {
        guard let color = color else { return }
        separator.backgroundColor = color
        separator.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth]
        separator.frame = CGRect(x: 0, y: 0, width: frame.width, height: height)
    }
    func addBottomBorder(with color: UIColor?, height: CGFloat) {
        guard let color = color else { return }
        let separator = UIView()
        separator.backgroundColor = color
        separator.autoresizingMask = [.flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleWidth]
        separator.frame = CGRect(x: 0, y: frame.height - height, width: frame.width, height: height)
        addSubview(separator)
    }
    func addTopBorder(with color: UIColor?, height: CGFloat) {
        guard let color = color else { return }
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
    
    @IBAction func handleIn() { UIView.animate(withDuration: 0.15) { self.alpha = 0.55 } }
    @IBAction func handleOut() { UIView.animate(withDuration: 0.15) { self.alpha = 1 } }
    
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}
