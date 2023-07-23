//
//  TeachersController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.03.2023.
//

import UIKit

final class TeachersController: TTBaseController {
    private lazy var dataSource: [Teacher] = APIManager.shared.getListOfTeachers()
    private var filteredData: [Teacher] = []
    
    override func refreshData() {
        self.collectionView.refreshControl?.beginRefreshing()
        if let isRefreshing = self.collectionView.refreshControl?.isRefreshing, isRefreshing {
            APIManager.shared.getTeachers { [weak self] (teachers, error) in
                DispatchQueue.main.async {
                    guard let self = self,
                          let teachers = teachers else { return }
                    self.dataSource = teachers
                    self.collectionView.reloadData()
                    
                }
            }
        }
        self.collectionView.refreshControl?.endRefreshing()
    }
}

extension TeachersController {
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = App.Strings.people
        // TODO: add refresh control
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        collectionView.register(TeacherCell.self, forCellWithReuseIdentifier: TeacherCell.reuseIdentifier)
    }
}

// MARK: -  UICollectionViewDataSource

extension TeachersController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { isFiltering() ? filteredData.count : dataSource.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeacherCell.reuseIdentifier, for: indexPath) as? TeacherCell
        else { return UICollectionViewCell() }
        if isFiltering() {
            cell.configure(with: Teacher(name: filteredData[indexPath.item].name,
                                         position: filteredData[indexPath.item].position,
                                         department: filteredData[indexPath.item].department,
                                         publications: filteredData[indexPath.item].publications,
                                         applications: filteredData[indexPath.item].applications,
                                         grants: filteredData[indexPath.item].grants,
                                         projects: filteredData[indexPath.item].projects,
                                         personalLink: filteredData[indexPath.item].personalLink))
        } else {
            cell.configure(with: Teacher(name: dataSource[indexPath.item].name,
                                         position: dataSource[indexPath.item].position,
                                         department: dataSource[indexPath.item].department,
                                         publications: dataSource[indexPath.item].publications,
                                         applications: dataSource[indexPath.item].applications,
                                         grants: dataSource[indexPath.item].grants,
                                         projects: dataSource[indexPath.item].projects,
                                         personalLink: dataSource[indexPath.item].personalLink))
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TeacherController()
        vc.link = isFiltering() ? filteredData[indexPath.row].personalLink : dataSource[indexPath.row].personalLink
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TeachersController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let item = isFiltering() ? filteredData[indexPath.row] : dataSource[indexPath.row]
        
        let heightForLabelname = heightForLabel(text: item.name, font: App.Fonts.helveticaNeue(with: 19), width: width)
        let heightForLabelposition = heightForLabel(text: item.position, font: App.Fonts.helveticaNeue(with: 17), width: width)
        let heightForLabeldepartment = heightForLabel(text: item.department, font: App.Fonts.helveticaNeue(with: 17), width: width)
        let heightForLabelpublications = heightForLabel(text: String("\(item.publications)"), font: App.Fonts.helveticaNeue(with: 17), width: width)
        let heightForLabelapplications = heightForLabel(text: String("\(item.applications)"), font: App.Fonts.helveticaNeue(with: 17), width: width)
        let heightForLabelgrants = heightForLabel(text: String("\(item.grants)"), font: App.Fonts.helveticaNeue(with: 17), width: width)
        let heightForLabelprojects = heightForLabel(text: String("\(item.projects)"), font: App.Fonts.helveticaNeue(with: 17), width: width)
        
        let totalHeight = heightForLabelname + heightForLabelposition + heightForLabeldepartment + heightForLabelpublications + heightForLabelapplications + heightForLabelgrants + heightForLabelprojects + 52
        return CGSize(width: width, height: totalHeight)
    }
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

extension TeachersController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text)
    }
    private func filterContentForSearchText(_ searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            filteredData = dataSource.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredData = dataSource
        }
        collectionView.reloadData()
    }
    private func isFiltering() -> Bool {
        return navigationItem.searchController?.isActive ?? false && !(navigationItem.searchController?.searchBar.text?.isEmpty ?? true)
    }
}
