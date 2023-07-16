//
//  FacultiesController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit

final class FacultiesController: TTBaseController {
    private let Faculties = APIManager.shared.getFaculties()
}

// MARK: - Configure

extension FacultiesController {
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = "TimetableSPBU"
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.SettingsCellId)
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension FacultiesController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { Faculties.count }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BaseCell.SettingsCellId, for: indexPath
        ) as? BaseCell else { return UICollectionViewCell() }
        let faculty = Faculties[indexPath.row]
        cell.configure(title: faculty.text, textAlignment: .center)
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
        UserDefaults.standard.link += Faculties[indexPath.row].href
        navigationController?.pushViewController(DirectionFacultyController(), animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FacultiesController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let item = Faculties[indexPath.item].text
        let height = heightForLabel(text: item, font: App.Fonts.helveticaNeue(with: 17), width: width) + 32
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 16, left: 0.0, bottom: 16.0, right: 0.0) }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: 0, height: 0) }
}
