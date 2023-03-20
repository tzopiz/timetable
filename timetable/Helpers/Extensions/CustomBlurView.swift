//
//  CustomBlurView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 20.03.2023.
//

import Foundation
import UIKit

@IBDesignable
class CustomUIVisualEffectView: UIVisualEffectView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.cornerCurve = .continuous
            layer.masksToBounds = true
        }
    }
}

@IBDesignable
class CustomUIView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.cornerCurve = .continuous
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: Int = 0 {
        didSet {
            layer.shadowOffset = CGSize(width: 0, height: shadowOffset)
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}

