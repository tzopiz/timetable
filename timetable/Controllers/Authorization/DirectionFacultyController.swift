//
//  DirectionFacultyController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit

final class DirectionFacultyController: TTBaseController {
    
    private var directions: [Section] = APIManager.shared.getGroupsTitles()

    @IBAction func toggleSection(_ sender: TTButton) {
        let section = sender.tag
        directions[section].isExpanded.toggle()
        collectionView.reloadSections(IndexSet(integer: section))
    }
}

// MARK: -Configure

extension DirectionFacultyController {
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = APIManager.shared.getTitle()
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.link = "https://timetable.spbu.ru"
        super.viewWillDisappear(animated)
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension DirectionFacultyController {
    func numberOfSections(in collectionView: UICollectionView) -> Int { directions.count }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int)
    -> Int { directions[section].isExpanded ? directions[section].items.count : 0 }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
        let item = directions[indexPath.section].items[indexPath.item]
        
        cell.configure(item)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HeaderView.reuseIdentifier,
                                                                         for: indexPath) as! HeaderView
        let section = directions[indexPath.section]
        headerView.configure(with: section.title, status: section.isExpanded, tag: indexPath.section,
                             target: self, action: #selector(toggleSection(_:)))
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

extension DirectionFacultyController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let item = directions[indexPath.section].items[indexPath.row]
        let height = heightForLabel(text: item, font: App.Fonts.helveticaNeue(with: 17), width: width) + 16
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) } // Отступы секций
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let section = directions[section]
        let height = heightForLabel(text: section.title, font: App.Fonts.helveticaNeue(with: 19), width: width) + 16
        
        return CGSize(width: width - 32, height: height)
    }
}

