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
    @objc func handleIn() { UIView.animate(withDuration: 0.15) { self.alpha = 0.55 } }
    @objc func handleOut() { UIView.animate(withDuration: 0.15) { self.alpha = 1 } }
    @objc func setupView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    func roundCorners(with borderLayer: inout CAShapeLayer, _ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
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
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                bottom: NSLayoutYAxisAnchor? = nil,
                paddingBottom: CGFloat = 0,
                left: NSLayoutXAxisAnchor? = nil,
                paddingLeft: CGFloat = 0,
                right: NSLayoutXAxisAnchor? = nil,
                paddingRight: CGFloat = 0,
                centerY: NSLayoutYAxisAnchor? = nil,
                centerX: NSLayoutXAxisAnchor? = nil,
                width: NSLayoutDimension? = nil,
                height: NSLayoutDimension? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top { topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true }
        if let bottom = bottom { bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true }
        if let left = left { leadingAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true }
        if let right = right { trailingAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true }
        if let width = width { widthAnchor.constraint(equalTo: width).isActive = true }
        if let height = height { heightAnchor.constraint(equalTo: height).isActive = true }
        if let centerY = centerY { centerYAnchor.constraint(equalTo: centerY).isActive = true }
        if let centerX = centerX { centerXAnchor.constraint(equalTo: centerX).isActive = true }
    }
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        if let topAnchor = topAnchor,
           let padding = paddingTop {
            topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        }
    }
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor) .isActive = true
        if let leftAnchor = leftAnchor,
           let padding = paddingLeft {
            leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    func setDimensions(height: CGFloat? = nil, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width { widthAnchor.constraint(equalToConstant: width).isActive = true }
        if let height = height { heightAnchor.constraint(equalToConstant: height).isActive = true }
    }
    func createCustomBackgroundView(with cornerRadius: CGFloat, shadowOfSet: Int) {
        let customV = CustomUIView()
        let blur = UIBlurEffect(style: .regular)
        let customVEV = CustomUIVisualEffectView(effect: blur)
        
        customV.cornerRadius = cornerRadius
        customV.shadowOpacity = 0.4
        customV.shadowOffset = shadowOfSet
        customV.borderWidth = 0.4
        customV.borderColor = .black
        customV.shadowColor = .black
        customVEV.cornerRadius = cornerRadius
        
        customV.translatesAutoresizingMaskIntoConstraints = false
        customVEV.translatesAutoresizingMaskIntoConstraints = false
        customV.backgroundColor = .clear
        customVEV.backgroundColor = .clear
        customV.addSubview(customVEV)
        insertSubview(customV, at: 0)
        
        NSLayoutConstraint.activate([
            customV.centerYAnchor.constraint(equalTo: centerYAnchor),
            customV.centerXAnchor.constraint(equalTo: centerXAnchor),
            customV.heightAnchor.constraint(equalTo: heightAnchor),
            customV.widthAnchor.constraint(equalTo: widthAnchor),
            
            customVEV.centerYAnchor.constraint(equalTo: centerYAnchor),
            customVEV.centerXAnchor.constraint(equalTo: centerXAnchor),
            customVEV.heightAnchor.constraint(equalTo: heightAnchor),
            customVEV.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
}
