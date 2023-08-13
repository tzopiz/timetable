//
//  SearchableTopBarView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 13.08.2023.
//

import UIKit

final class SearchableTopBarView: TTBaseView, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Teachers"
        label.font = App.Fonts.helveticaNeue(with: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupView(titleLabel)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        
        // Добавьте поисковую строку на представление
        addSubview(searchController.searchBar)
    }
    
    override func constraintViews() {
        super.constraintViews()
        
        titleLabel.anchor(top: topAnchor, paddingTop: 0, centerX: centerXAnchor)
        searchController.searchBar.anchor(top: titleLabel.bottomAnchor, paddingTop: 8, left: leadingAnchor, right: trailingAnchor)
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        backgroundColor = App.Colors.BlackWhite
    }
}
