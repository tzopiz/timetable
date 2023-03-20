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
    fileprivate let untiBag = UIView(frame: .zero)
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear

        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
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
}

extension TTBaseController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int)
    -> Int { 0 }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell { UICollectionViewCell() }
}
extension TTBaseController: UICollectionViewDataSource {}
extension TTBaseController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int)
    -> CGFloat { 16 }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: collectionView.frame.width, height: 40) }
}

@objc extension TTBaseController {
    func setupViews() {
        view.setupView(untiBag)
        view.setupView(collectionView)
        
    }
    func constraintViews() {
       
        collectionView.anchor(top: view.topAnchor,
                              bottom: view.bottomAnchor,
                              left: view.leadingAnchor,
                              right: view.trailingAnchor)
    }
    func configureAppearance() {
        let backgroundImgaeView = UIImageView(image: #imageLiteral(resourceName: "BackPolygons"))
        backgroundImgaeView.frame = collectionView.frame
        view.insertSubview(backgroundImgaeView, at: 0)
        backgroundImgaeView.anchor(top: view.topAnchor,
                                   bottom: view.bottomAnchor,
                                   left: view.leadingAnchor,
                                   right: view.trailingAnchor)
        view.backgroundColor = .clear
        untiBag.isHidden = true
    }
    func navBarLeftButtonHandler() { print("NavBar left button tapped") }
    func navBarRightButtonHandler() { print("NavBar right button tapped") }
}
