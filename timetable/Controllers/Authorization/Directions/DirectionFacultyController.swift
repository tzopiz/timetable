//
//  DirectionFacultyController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit


final class DirectionFacultyController: TTBaseController {
    private var directions: [Section] = APIManager.shared.getSections()

    @objc func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        directions[section].isExpanded.toggle()
        
        collectionView.reloadSections(IndexSet(integer: section))
    }
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
        navigationItem.title = APIManager.shared.getTitle()
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let url = URL(string: UserDefaults.standard.link)!
        let newLink = url.deletingLastPathComponent().absoluteString
        UserDefaults.standard.link = String(newLink.dropLast())
    }

}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension DirectionFacultyController {
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return directions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return directions[section].isExpanded ? directions[section].items.count : 0
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
        
        let item = directions[indexPath.section].items[indexPath.item]
        cell.textLabel.text = item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: HeaderView.reuseIdentifier,
                                                                         for: indexPath) as! HeaderView
        
        let section = directions[indexPath.section]
        let isOpen = section.isExpanded
        let imageName = isOpen ? "chevron.down" : "minus"
        
        headerView.titleLabel.text = section.title
        headerView.expandButton.tag = indexPath.section
        headerView.expandButton.setImage(UIImage(systemName: imageName), for: .normal)
        headerView.expandButton.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)
        
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
        let width = collectionView.frame.width
        let height: CGFloat = 44
        return CGSize(width: width - 32, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 44
        return CGSize(width: width - 32, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) // Отступы секций
    }

}

