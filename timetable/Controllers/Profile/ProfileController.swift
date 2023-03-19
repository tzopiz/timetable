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

final class ProfileController: TTBaseController {
    private var dataSource: [SettingsData] = []
}

extension ProfileController {
    override func setupViews() {
        super.setupViews()
    }
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = App.Strings.profile
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)

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
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCell.reuseID,
            for: indexPath) as? ProfileCell
        else { fatalError("###\(#function): Wrong cell") }
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
extension ProfileController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
         indexPath.item == 0 ? CGSize(width: collectionView.frame.width - 32, height: 120) : CGSize(width: collectionView.frame.width - 32, height: 65)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16.0, bottom: 16.0, right: 16.0)
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
         CGSize(width: collectionView.frame.width, height: 0)
     }
}
