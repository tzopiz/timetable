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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = App.Strings.people
        configureHierarchy()
        configureDataSource()
        performQuery(with: nil)
    }
}

extension PeopleViewController {
    func configureDataSource() {
        
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
    
    /// - Tag: PeoplePerformQuery
    func performQuery(with filter: String?) {
        let mountains = peopleController.filteredMountains(with: filter).sorted { $0.name < $1.name }

        var snapshot = NSDiffableDataSourceSnapshot<Section, PeopleController.People>()
        snapshot.appendSections([.main])
        snapshot.appendItems(mountains)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PeopleViewController {
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

    func configureHierarchy() {
        view.backgroundColor = App.Colors.background
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = App.Colors.background
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let untibag = UIView()
        untibag.isHidden = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(untibag)
        view.addSubview(collectionView)
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -1),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        peopleCollectionView = collectionView

        searchBar.delegate = self
    }
}

extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
}

