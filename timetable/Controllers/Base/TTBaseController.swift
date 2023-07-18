//
//  TTBaseController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

enum NavBarPosition {
    case left
    case right
}

class TTBaseController: UIViewController {
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        
        return view
    }()
    public func update() {
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constraintViews()
        configureAppearance()
    }
    func addNavBarButton(at position: NavBarPosition, with title: String) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(App.Colors.active, for: .normal)
        button.setTitleColor(App.Colors.inactive, for: .disabled)
        button.titleLabel?.font = App.Fonts.helveticaNeue(with: 17)
        
        switch position {
        case .left:
            button.addTarget(self, action: #selector(navBarLeftButtonHandler), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        case .right:
            button.addTarget(self, action: #selector(navBarRightButtonHandler), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    func scrollCollectionViewToTop() { self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true) }
    func heightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = TTLabel()
        label.text = text
        label.font = font
        
        
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return size.height
    }
}

// MARK: - UICollectionViewDataSource

extension TTBaseController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDataSource

extension TTBaseController: UICollectionViewDelegate { }

//MARK: - UICollectionViewDelegateFlowLayout

extension TTBaseController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int)
    -> CGFloat { 8 }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: collectionView.frame.width, height: 32) }
}

@objc
extension TTBaseController {
    /// Добавляет подвиды на контроллер.
    func setupViews() {
        // Добавьте код для добавления подвидов на контроллер,
        // таких как их инициализация, настройка свойств и добавление на представление.
        view.setupView(collectionView)
    }
    
    /// Устанавливает ограничения для подвидов внутри контроллера.
    func constraintViews() {
        // Добавьте код для установки ограничений для подвидов,
        // таких как установка автолейаут-ограничений, задание отступов и т.д.
        collectionView.anchor(top: view.topAnchor,
                              bottom: view.bottomAnchor,
                              left: view.leadingAnchor,
                              right: view.trailingAnchor)
    }
    
    /// Настраивает внешний вид контроллера.
    func configureAppearance() {
        // Добавьте код для настройки внешнего вида контроллера,
        // таких как установка фона, цветов, шрифтов и других свойств визуальных элементов.
        // Вы также можете применять стили, добавлять тени, закруглять углы и т.д.
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = App.Colors.background
    }
    func navBarLeftButtonHandler() { print("NavBar left button tapped") }
    func navBarRightButtonHandler() { print("NavBar right button tapped") }
}
