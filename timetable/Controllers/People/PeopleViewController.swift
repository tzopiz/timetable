//
//  PeopleViewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.03.2023.
//

import UIKit

final class PeopleViewController: TTBaseController {
    
    private var searchController: UISearchController!
    private var data: [Teacher] = APIManager.shared.getTeachers()
    private var filteredData: [Teacher] = []
}
extension PeopleViewController {
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = App.Strings.people
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.baseId)
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: -  UICollectionViewDataSource

extension PeopleViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { isFiltering() ? filteredData.count : data.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCell.baseId, for: indexPath) as? BaseCell
        else { return UICollectionViewCell() }
        let text: String
        if isFiltering() { text = filteredData[indexPath.item].name + "\n" + filteredData[indexPath.item].info }
        else { text = data[indexPath.item].name + "\n" + data[indexPath.item].info }
        cell.configure(title: text)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PeopleViewController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize { CGSize(width: collectionView.frame.width - 32, height: 65) }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets {  UIEdgeInsets(top: 16, left: 16.0, bottom: 16.0, right: 16.0) }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: collectionView.frame.width, height: 0) }
}

// MARK: - UISearchResultsUpdating

extension PeopleViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text)
    }
    private func filterContentForSearchText(_ searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            filteredData = data.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredData = data
        }
        collectionView.reloadData()
    }
    private func isFiltering() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
}
