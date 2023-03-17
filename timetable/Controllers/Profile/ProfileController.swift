//
//  ProfileController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

struct SettingsData {
    struct Data {
        let title: String
        let image: UIImage
        let type: CellType
    }
    let item: Data
}

class ProfileController: TTBaseController {
    
    private let untiBag = UIView(frame: .zero)
    private var dataSource: [SettingsData] = []
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear

        return view
    }()
}

extension ProfileController {
    override func setupViews() {
        super.setupViews()
        view.addSubview(untiBag)
        view.setupView(collectionView)
        collectionView.contentInset = .zero
    }

    override func constraintViews() {
        super.constraintViews()
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              left: view.leadingAnchor, paddingLeft: 16,
                              right: view.trailingAnchor, paddingRight: -16)
    }
    override func configureAppearance() {
        super.configureAppearance()
        self.untiBag.isHidden = true
        navigationItem.title = App.Strings.profile
       
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseID)
        dataSource = [
            .init(item: .init(title: "Фамилия Имя Отчество",  image: App.Images.imageProfile, type: .profile)),
            .init(item: .init(title: App.Strings.changeGroup, image: App.Images.changeGroup,  type: .base)),
            .init(item: .init(title: App.Strings.appearance,  image: App.Images.theme,        type: .theme)),
            .init(item: .init(title: App.Strings.exit,        image: App.Images.exit,         type: .exit)),
            .init(item: .init(title: App.Strings.aboutApp,    image: App.Images.aboutApp,     type: .base))
        ]
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension ProfileController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseID,
                                                            for: indexPath) as? ProfileCell else {
            fatalError("Wrong cell")
        }
        let item = dataSource[indexPath.row].item
        cell.configure(title: item.title, type: item.type, image: item.image)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ProfileCell
        cell?.isHighlighted()
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ProfileCell
        cell?.isUnHighlighted()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize: CGSize
        let sectionInsets = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 0.0, right: 0.0)
        let itemWidth = collectionView.bounds.width - (sectionInsets.left + sectionInsets.right)
        itemSize = indexPath.item == 0 ? CGSize(width: itemWidth, height: 120) : CGSize(width: itemWidth, height: 65)
        return itemSize
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 16
    }
}
