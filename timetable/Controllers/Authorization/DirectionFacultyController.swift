//
//  DirectionFacultyController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit

final class DirectionFacultyController: TTBaseController {
    private let directions = ["Бакалавриат", "Доп На Базе Впо 1 Уровня (Ступени)", "Магистратура", "Подготовка Научно-Педагогических Кадров В Аспирантуре"]
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
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.SettingsCellId)
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension DirectionFacultyController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { directions.count }

    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BaseCell.SettingsCellId, for: indexPath
        ) as? BaseCell else { return UICollectionViewCell() }
        let faculty = directions[indexPath.row]
        cell.configure(title: faculty, textAlignment: .center)
        return cell
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
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DirectionFacultyController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0.0, bottom: 16.0, right: 0.0)
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
     -> CGSize { CGSize(width: 0, height: 0) }
}
