//
//  UIColor + ext.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: CGFloat(alpha) / 255)
    }
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
            if #available(iOS 13.0, *) {
                return UIColor(dynamicProvider: {
                    switch $0.userInterfaceStyle {
                    case .dark:
                        return dark
                    case .light, .unspecified:
                        return light
                    @unknown default:
                        assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                        return light
                    }
                })
            }
            // iOS 12 and earlier
            return light
        }
}
