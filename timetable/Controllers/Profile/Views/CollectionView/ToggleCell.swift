//
//  ToggleCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 13.08.2023.
//

import UIKit

final class ToggleCell: BaseCell {
    override class var reuseIdentifier: String { return String(describing: ToggleCell.self) }
    private let switcher = UISwitch()
    weak var delegate: UICollectionViewUpdatable?
}

extension ToggleCell {
    override func setupViews() {
        super.setupViews()
        setupView(switcher)
    }
    override func constraintViews() {
        super.constraintViews()
        switcher.anchor(right: trailingAnchor, paddingRight: -20, centerY: centerYAnchor)
    }
    override func configureAppearance() {
        super.configureAppearance()
        switcher.isOn = UserDefaults.standard.cachingTimetable
        switcher.onTintColor = App.Colors.active
        switcher.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
}
extension ToggleCell {
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if !switcher.isOn {
            let alert = UIAlertController(title: "Внимание", message: "Вы точно хотите удалить кеш?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel,  handler: { (action: UIAlertAction) in
                self.switcher.isOn = true
            }))
            alert.addAction(UIAlertAction(title: "Очистить", style: .destructive,  handler: { (action: UIAlertAction) in
                UserDefaults.standard.cachingTimetable = sender.isOn
                let cacheManager = DataCacheManager()
                cacheManager.clearCache()
                self.delegate?.updateCollectionView()
            }))
            let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = windowScenes?.windows.first
            let viewController = window?.rootViewController
            viewController?.present(alert, animated: true, completion: nil)
        } else { UserDefaults.standard.cachingTimetable = sender.isOn }
    }
}
