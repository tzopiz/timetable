//
//  GroupsController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 16.07.2023.
//

import UIKit

final class GroupsController: TTBaseController {
    
    private var groups: [Auth.SectionWithLinks] = []

    @IBAction func toggleSection(_ sender: TTButton) {
        let section = sender.tag
        groups[section].isExpanded.toggle()
        collectionView.reloadSections(IndexSet(integer: section))
    }
}

// MARK: -Configure

extension GroupsController {
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = ""
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.reuseIdentifier)
        collectionView.register(HeaderWithButtonView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderWithButtonView.reuseIdentifier)
        self.collectionView.refreshControl?.beginRefreshing()
        APIManager.shared.loadStudentGroupEvents { [weak self] sectionWithLinks in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.groups = sectionWithLinks
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension GroupsController {
    func numberOfSections(in collectionView: UICollectionView) -> Int { groups.count }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int)
    -> Int { groups[section].isExpanded ? groups[section].items.count : 0 }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCell.reuseIdentifier, for: indexPath) as! BaseCell
        let item = groups[indexPath.section].items[indexPath.item]
        let width = collectionView.bounds.width - 32
        let height = heightForLabel(text: item.text, font: App.Fonts.helveticaNeue(with: 17), width: width) + 16
        cell.configure(title: item.text, cornerRadius: height / 4)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HeaderWithButtonView.reuseIdentifier,
                                                                         for: indexPath) as! HeaderWithButtonView
        let section = groups[indexPath.section]
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
        UserDefaults.standard.groupsLink = UserDefaults.standard.link
        UserDefaults.standard.link = "https://timetable.spbu.ru" + groups[indexPath.section].items[indexPath.item].link
        UserDefaults.standard.registered = true
        UserDefaults.standard.group = groups[indexPath.section].items[indexPath.item].text
        
        let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScenes?.windows.first?.switchRootViewController(TabBarController())
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GroupsController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let item = groups[indexPath.section].items[indexPath.row]
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
        let section = groups[section]
        let height = heightForLabel(text: section.title, font: App.Fonts.helveticaNeue(with: 19), width: width - 32) + 16
        
        return CGSize(width: width, height: height)
    }
}

