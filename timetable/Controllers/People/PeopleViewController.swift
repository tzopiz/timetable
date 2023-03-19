//
//  PeopleViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.03.2023.
//

import UIKit

class PeopleViewController: TTBaseController {

    enum Section: CaseIterable {
        case main
    }
    let peopleController = PeopleController()
    let searchBar = UISearchBar(frame: .zero)
    var peopleCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, PeopleController.People>!
    var nameFilter: String?
    
    func performQuery(with filter: String?) {
        let mountains = peopleController.filteredMountains(with: filter).sorted { $0.name < $1.name }

        var snapshot = NSDiffableDataSourceSnapshot<Section, PeopleController.People>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mountains)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let columns = 1
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(70))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            // let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

            return section
        }
        return layout
    }
}

extension PeopleViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        performQuery(with: nil)
    }
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = App.Strings.people
        let cellRegistration = UICollectionView.CellRegistration
        <LabelCell, PeopleController.People> { (cell, indexPath, people) in
            cell.label.text = people.name
            cell.sublabel.text = people.info
            cell.backgroundColor = App.Colors.BlackWhite
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PeopleController.People>(collectionView: peopleCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: PeopleController.People) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    override func constraintViews() {
        super.constraintViews()
        view.backgroundColor = App.Colors.background
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = App.Colors.background
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let untibag = UIView()
        untibag.isHidden = true
        view.addSubview(untibag)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: -1,
                         left: view.leadingAnchor, paddingLeft: 0,
                         right: view.trailingAnchor, paddingRight: 0)
        collectionView.anchor(top: searchBar.bottomAnchor,
                              bottom: view.bottomAnchor,
                              left: view.leadingAnchor,
                              right: view.trailingAnchor)
        
        peopleCollectionView = collectionView
        searchBar.delegate = self
    }
}
// MARK: UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

