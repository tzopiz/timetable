//
//  DirectionsController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 16.07.2023.
//

import UIKit

final class DirectionsController: TTBaseController {
    private var directions: [String] = []
    private var headerTitle = ""
}

// MARK: - Configure

extension DirectionsController {
    override func configureViews() {
        super.configureViews()
        navigationController?.navigationBar.addBottomBorder(with: R.color.separator(), height: 1)
        title = "Направления"
        
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.reuseIdentifier)
        collectionView.register(SectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionView.reuseIdentifier)
    }
    override func refreshData() {
        collectionView.refreshControl?.beginRefreshing()
        APIManager.shared.loadDirectionsTitles { [weak self] directions in
            guard let self = self else { return }
            APIManager.shared.loadTitle { [weak self] title in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let title = title { self.headerTitle = title }
                    else { self.headerTitle = "" }
                    self.directions = directions
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension DirectionsController {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int { directions.count }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCell.reuseIdentifier,
                                                            for: indexPath) as? BaseCell
        else { return UICollectionViewCell() }
        let item = directions[indexPath.item]
        let width = collectionView.bounds.width - 32
        let height = heightForLabel(text: item, font: R.font.robotoRegular(size: 17)!, width: width) + 16
        cell.configure(title: item, cornerRadius: height / 4)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: SectionView.reuseIdentifier,
                                                                               for: indexPath) as? SectionView
        else { return UICollectionReusableView() }
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
        let vc = GroupsTitlesController()
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DirectionsController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let item = directions[indexPath.item]
        let height = heightForLabel(text: item, font: R.font.robotoRegular(size: 17)!, width: width) + 16
        
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
        let height = heightForLabel(text: headerTitle, font: R.font.robotoRegular(size: 19)!, width: width - 32) + 16
        return CGSize(width: width, height: height)
    }
}

