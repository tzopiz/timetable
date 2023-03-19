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
    var peopleCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, PeopleController.People>!
    var nameFilter: String?
    
    func performQuery(with filter: String?) {
        let mountains = peopleController.filteredPeople(with: filter).sorted { $0.name < $1.name }

        var snapshot = NSDiffableDataSourceSnapshot<Section, PeopleController.People>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mountains)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let columns = 2
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(70))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: columns)
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
    override func constraintViews() {
        super.constraintViews()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout())
        collectionView.backgroundColor = App.Colors.background
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor,
                              bottom: view.bottomAnchor,
                              left: view.leadingAnchor,
                              right: view.trailingAnchor)
        
        peopleCollectionView = collectionView
    }
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = App.Strings.people
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1/3)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        let cellRegistration = UICollectionView.CellRegistration
        <LabelCell, PeopleController.People> { (cell, indexPath, people) in
            cell.label.text = people.name
            cell.sublabel.text = people.info
            cell.backgroundColor = App.Colors.BlackWhite
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, PeopleController.People> (collectionView: peopleCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: PeopleController.People) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}

// MARK: - searchResultsUpdater
extension PeopleViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        performQuery(with: searchController.searchBar.text)
    }
}
