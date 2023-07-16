//
//  AuthorizationController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 06.04.2023.
//

import UIKit

final class AuthorizationController: TTBaseController {
    private let kindTimetable = ["Студент", "Преподаватель"]
}

// MARK: - Configure

extension AuthorizationController {
    override func configureAppearance() {
        super.configureAppearance()
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.baseId)
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)

        
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension AuthorizationController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { kindTimetable.count }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BaseCell.baseId, for: indexPath
        ) as? BaseCell else { return UICollectionViewCell() }
        let data = kindTimetable[indexPath.row]
        cell.configure(title: data, textAlignment: .center, textSize: 32)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: navigationController?.pushViewController(FacultiesController(), animated: true)
        default: break
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? BaseCell
        cell?.isHighlighted()
    }
    func collectionView(_ collectionView: UICollectionView,
                        didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? BaseCell
        cell?.isUnHighlighted()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AuthorizationController {
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 minimumLineSpacingForSectionAt section: Int)
    -> CGFloat { 32 }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize { CGSize(width: collectionView.frame.width - 64, height: 100) }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 16, left: 0.0, bottom: 16.0, right: 0.0) }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: 0, height: self.view.frame.width / 2) }
}
