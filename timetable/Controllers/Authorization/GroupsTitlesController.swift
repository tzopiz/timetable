//
//  GroupsTitlesController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit

final class GroupsTitlesController: TTBaseController {
    var index = 0
    private lazy var groupsTitles: [SectionWithLinks] = APIManager.shared.getGroupsTitles()[index]
    private var isNotFirstLoad = false
    @IBAction func toggleSection(_ sender: TTButton) {
        let section = sender.tag
        groupsTitles[section].isExpanded.toggle()
        collectionView.reloadSections(IndexSet(integer: section))
    }
}

// MARK: -Configure

extension GroupsTitlesController {
    override func configureAppearance() {
        super.configureAppearance()
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.baseId)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.link.count > 30 {
            let urlString = UserDefaults.standard.link
            if let url = URL(string: urlString) {
                let newURL = url.deletingLastPathComponent().deletingLastPathComponent()
                UserDefaults.standard.link = String(newURL.absoluteString.dropLast())
            }
        }
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension GroupsTitlesController {
    func numberOfSections(in collectionView: UICollectionView) -> Int { groupsTitles.count }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int)
    -> Int { groupsTitles[section].isExpanded ? groupsTitles[section].items.count : 0 }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCell.baseId, for: indexPath) as! BaseCell
        let item = groupsTitles[indexPath.section].items[indexPath.item]
        let width = collectionView.bounds.width - 32
        let height = heightForLabel(text: item.text, font: App.Fonts.helveticaNeue(with: 17), width: width) + 16
        cell.configure(title: item.text, cornerRadius: height / 4)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HeaderView.reuseIdentifier,
                                                                         for: indexPath) as! HeaderView
        let section = groupsTitles[indexPath.section]
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
        UserDefaults.standard.link = "https://timetable.spbu.ru" + groupsTitles[indexPath.section].items[indexPath.item].link
        navigationController?.pushViewController(GroupsController(), animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GroupsTitlesController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let item = groupsTitles[indexPath.section].items[indexPath.row]
        let height = heightForLabel(text: item.text, font: App.Fonts.helveticaNeue(with: 17), width: width) + 16
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) } // Отступы секций
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let section = groupsTitles[section]
        let height = heightForLabel(text: section.title, font: App.Fonts.helveticaNeue(with: 19), width: width - 32) + 16
        
        return CGSize(width: width, height: height)
    }
}

