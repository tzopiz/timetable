//
//  DirectionFacultyController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit

final class DirectionFacultyController: TTBaseController {
    let diresctions = Faculty(directions: directions)
}

// MARK: -Configure

extension DirectionFacultyController {
    override func setupViews() {
        super.setupViews()
    }
    override func constraintViews() {
        super.constraintViews()
    }
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = "TimetableSPBU"
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.SettingsCellId)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.id)
        
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension DirectionFacultyController {
    func numberOfSections(in collectionView: UICollectionView)
    -> Int { directions.count }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { directions[section].items.count }

    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BaseCell.SettingsCellId, for: indexPath
        ) as? BaseCell else { return UICollectionViewCell() }
        let faculty = directions[indexPath.section].items[indexPath.row]
        cell.configure(title: faculty, textAlignment: .left, textSize: 15)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionHeaderView.id,
                                                                         for: indexPath) as? SectionHeaderView
        else { return UICollectionReusableView() }

        view.configure(with: directions[indexPath.section].name, textSize: 17)
        return view
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
        CGSize(width: collectionView.frame.width - 32, height: 55)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == directions.count - 1 {
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)
        } else {
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        }
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: collectionView.frame.width, height: 64) }
}
