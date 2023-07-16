//
//  AppearenceCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 29.03.2023.
//

import UIKit

final class AppearenceCell: BaseCell {
    
    static let AppearenceCellId = String(describing: AppearenceCell.self)
    private let button = TTButton(with: .secondary)
    
    func configure(title: String, type: CellType = .base, image: UIImage? = nil) {
        super.configure(title: title, type: type, image: image)
        if type == .theme {
            setupView(button)
            let title = UserDefaults.standard.theme.getUserInterfaceStyle() == .dark ?
            "Темная": UserDefaults.standard.theme.getUserInterfaceStyle() == .light ?
            "Светлая" : "Системная"
            button.setTitle(title)
            button.setFontSize(18)
            button.addButtonTarget(target: self, action: #selector(showAlertController))
            button.setDimensions(height: 40)
            button.anchor(right: trailingAnchor, paddingRight: -16,
                          centerY: centerYAnchor)
        }
    }
    @IBAction func showAlertController() {
        showInputDialog(firstTitle: "Светлое",
                        secondTitle: "Темное",
                        thirdTitle: "Системное",
                        cancelTitle: "Отмена")
    }
    func showInputDialog(firstTitle: String, secondTitle: String, thirdTitle: String, cancelTitle: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        let viewController = window?.rootViewController
        func updateData() {
            window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.getUserInterfaceStyle()
            let title = UserDefaults.standard.theme.getUserInterfaceStyle() == .dark ? "Темное": UserDefaults.standard.theme.getUserInterfaceStyle() == .light ? "Светлое" : "Системное"
            self.button.setTitle(title)
        }
        alert.addAction(UIAlertAction(title: firstTitle, style: .default,  handler: { (action: UIAlertAction) in
            UserDefaults.standard.theme = .light
            updateData()
        }))
        alert.addAction(UIAlertAction(title: secondTitle, style: .default, handler: { (action: UIAlertAction) in
            UserDefaults.standard.theme = .dark
            updateData()
        }))
        alert.addAction(UIAlertAction(title: thirdTitle, style: .default,  handler: { (action: UIAlertAction) in
            UserDefaults.standard.theme = .device
            updateData()
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
}

