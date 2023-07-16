//
//  DirectionsViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 16.07.2023.
//

import UIKit

final class DirectionsViewController: TTBaseController {
    
    private var directions: [String] = APIManager.shared.getDirections()
    private let headerTitle = APIManager.shared.getTitle()
}

// MARK: -Configure

extension DirectionsViewController {
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = "TimetableSPBU"
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.link = "https://timetable.spbu.ru"
        super.viewWillDisappear(animated)
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension DirectionsViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int)
    -> Int { directions.count }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
        let item = directions[indexPath.item]
        
        cell.configure(item)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                                                                         for: indexPath) as! SectionHeaderView
        headerView.configure(with: headerTitle, textSize: 19)
        return headerView
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let yVC = YearAdmissionController()
        navigationController?.pushViewController(yVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DirectionsViewController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let item = directions[indexPath.item]
        let height = heightForLabel(text: item, font: App.Fonts.helveticaNeue(with: 17), width: width) + 16
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16) } // Отступы секций
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let height = heightForLabel(text: headerTitle, font: App.Fonts.helveticaNeue(with: 19), width: width) + 16
        
        return CGSize(width: width - 32, height: height)
    }
}

