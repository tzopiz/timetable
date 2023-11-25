//
//  GroupsTitlesController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit

final class GroupsTitlesController: TTBaseController {
    
    var index = 0
    private var groupsTitles: [Auth.SectionWithLinks] = []
    
    @IBAction func toggleSection(_ sender: TTButton) {
        let section = sender.tag
        groupsTitles[section].isExpanded.toggle()
        collectionView.reloadSections(IndexSet(integer: section))
    }
}

// MARK: -Configure

extension GroupsTitlesController {
    override func configureViews() {
        super.configureViews()
        navigationController?.navigationBar.addBottomBorder(with: R.color.separator(), height: 1)
        title = "Программы"
        
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.reuseIdentifier)
        collectionView.register(HeaderWithButtonView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderWithButtonView.reuseIdentifier)
    }
    override func refreshData() {
        self.collectionView.refreshControl?.beginRefreshing()
        APIManager.shared.loadGroupsTitles { [weak self] sectionsWithLinks in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.index < sectionsWithLinks.count {
                    self.groupsTitles = sectionsWithLinks[self.index]
                }
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.link.count > 30 {
            let urlString = UserDefaults.standard.link
            if let url = URL(string: urlString) {
                let newURL = url.deletingLastPathComponent().deletingLastPathComponent()
                UserDefaults.standard.link = String(newURL.absoluteString.dropLast())
            }
        }
        super.viewWillAppear(animated)
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCell.reuseIdentifier,
                                                            for: indexPath) as? BaseCell
        else { return UICollectionViewCell() }
        let item = groupsTitles[indexPath.section].items[indexPath.item]
        let width = collectionView.bounds.width - 32
        let height = heightForLabel(text: item.text, font: R.font.robotoRegular(size: 17)!, width: width) + 16
        cell.configure(title: item.text, cornerRadius: height / 4)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind,
                                              withReuseIdentifier: HeaderWithButtonView.reuseIdentifier,
                                              for: indexPath) as? HeaderWithButtonView
        else { return UICollectionReusableView() }
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
        let width = collectionView.bounds.width - 32
        let item = groupsTitles[indexPath.section].items[indexPath.row]
        let height = heightForLabel(text: item.text, font: R.font.robotoRegular(size: 17)!, width: width) + 16
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) } // Отступы секций
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width - 32
        let section = groupsTitles[section]
        let height = heightForLabel(text: section.title, 
                                    font: R.font.robotoRegular(size: 19)!,
                                    width: width - 32) + 16
        
        return CGSize(width: width, height: height)
    }
}

