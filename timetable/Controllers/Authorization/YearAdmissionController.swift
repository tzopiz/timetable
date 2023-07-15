//
//  YearAdmissionController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit

struct YearAdmission {
    let year: String
    let groups: [String]
}

final class YearAdmissionController: TTBaseController {
    private let yearAdmission: [YearAdmission] = [
        YearAdmission(year: "2022", groups:  ["22.Б01", "22.Б02", "22.Б03", "22.Б04", "22.Б05"]),
        YearAdmission(year: "2021", groups:  ["21.Б01", "21.Б02"]),
        YearAdmission(year: "2020", groups:  ["20.Б01", "20.Б02", "20.Б03"]),
        YearAdmission(year: "2019", groups:  ["19.Б01"]),
        YearAdmission(year: "2018", groups:  ["18.Б01", "18.Б02", "18.Б30", "18.Б04"])
    ]
}

// MARK: - Configure

extension YearAdmissionController {
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = "TimetableSPBU"
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.SettingsCellId)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension YearAdmissionController {
    func numberOfSections(in collectionView: UICollectionView)
    -> Int { yearAdmission.count }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { yearAdmission[section].groups.count }

    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BaseCell.SettingsCellId, for: indexPath
        ) as? BaseCell else { return UICollectionViewCell() }
        let faculty = yearAdmission[indexPath.section].groups[indexPath.row]
        cell.configure(title: faculty, textAlignment: .left, textSize: 15)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                                                                         for: indexPath) as? SectionHeaderView
        else { return UICollectionReusableView() }

        view.configure(with: yearAdmission[indexPath.section].year, textSize: 17)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension YearAdmissionController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize { CGSize(width: collectionView.frame.width - 32, height: 55) }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == yearAdmission.count - 1 { return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0) }
        else { return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0) }
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: collectionView.frame.width, height: 64) }
}
