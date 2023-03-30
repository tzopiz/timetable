//
//  PeopleViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.03.2023.
//

import UIKit

class PeopleViewController: TTBaseController {
    let peopleController = PeopleController()
    var dataSource: [Teacher] = []
    var nameFilter: String?
    
    func performQuery(with filter: String?) {
        let peoples = peopleController.filteredPeople(with: filter).sorted { $0.name < $1.name }
        dataSource = peoples
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension PeopleViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        performQuery(with: nil)
    }
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = App.Strings.people
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1/3)

        self.collectionView.register(LabelCell.self,
                                forCellWithReuseIdentifier: LabelCell.reuseID)
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        
    }
    @objc func refreshData() {
        self.collectionView.refreshControl?.beginRefreshing()
        if let isRefreshing = self.collectionView.refreshControl?.isRefreshing, isRefreshing {
            APIManager.shared.getTeachres { [weak self] teachers in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.dataSource = teachers
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
        }
       
    }
}

// MARK: - UICollectionViewDataSource

extension PeopleViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LabelCell.reuseID, for: indexPath
        ) as? LabelCell else { return UICollectionViewCell() }
        cell.label.text = dataSource[indexPath.row].name
        cell.sublabel.text =  dataSource[indexPath.row].info
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PeopleViewController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width - 32, height: 65)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16.0, bottom: 16.0, right: 16.0)
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 0)
    }
}


// MARK: - searchResultsUpdater

extension PeopleViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        performQuery(with: searchController.searchBar.text)
    }
}
