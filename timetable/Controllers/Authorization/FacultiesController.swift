//
//  FacultiesController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit

final class FacultiesController: TTBaseController {
    private let Faculties =
    ["Академическая гимназия", "Биология", "Востоковедение", "Журналистика, Прикладные коммуникации", "Иностранные языки",
     "Институт развития конкуренции и антимонопольного регулирования СПбГУ", "Искусства", "История", "Когнитивные исследования",
     "Колледж физической культуры и спорта, экономики и технологии", "Математика и компьютерные науки",
     "Математика, Механика", "Медицина", "Междисциплинарные программы", "Международные отношения", "Менеджмент",
     "Науки о Земле", "Педагогика", "Политология", "Процессы управления", "Психология", "Свободные искусства и науки",
     "Социология", "Стоматология и медицинские технологии", "Управление научных исследований", "Физика", "Филология",
     "Философия", "Химия", "Экономика", "Юриспруденция"]

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
        let vc = DirectionFacultyController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FacultiesController {
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
