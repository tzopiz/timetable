//
//  UIImage + ext.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 31.03.2023.
//

import UIKit

extension UIImage {
    static func resizeImage(image: inout UIImage, targetSize: CGSize) {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = newImage ?? UIImage()
    }
    ///```
    ///// Предполагается, что у вас есть UIImage вашей одноцветной иконки
    /// let originalImage = UIImage(named: "your_one_color_icon")
    ///
    /// // Цвет, который вы хотите установить
    /// let desiredColor = UIColor.white
    ///
    /// // Применяем функцию для изменения цвета
    /// if let coloredImage = changeColorOfImage(image: originalImage, color: desiredColor) {
    ///     // Здесь вы можете использовать новую цветную иконку по своему усмотрению
    /// }
    ///```
    static func changeColorOfImage(image: UIImage, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        context?.clip(to: imageRect, mask: image.cgImage!)
        context?.fill(imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
