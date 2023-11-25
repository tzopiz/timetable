//
//  FacultiesController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 07.04.2023.
//

import UIKit

final class FacultiesController: TTBaseController {
    private var faculties: [(text: String, link: String)] = []
}

// MARK: - Configure

extension FacultiesController {
    override func configureViews() {
        super.configureViews()
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.reuseIdentifier)
        navigationController?.navigationBar.addBottomBorder(with: R.color.separator(), height: 1)
        title = "SPBU"
    }
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.link = "https://timetable.spbu.ru"
        super.viewWillAppear(animated)
    }
    override func refreshData() {
        collectionView.refreshControl?.beginRefreshing()
        APIManager.shared.loadFaculties { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if result.isEmpty {
                    self.collectionView.refreshControl?.endRefreshing()
                    UserDefaults.standard.link = "https://timetable.spbu.ru"
                    UserDefaults.standard.registered = true
                    UserDefaults.standard.group = "Выберете группу"
                    
                    let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScenes?.windows.first?.switchRootViewController(TabBarController())
                } else {
                    self.faculties = result
                    self.collectionView.reloadData()
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate

extension FacultiesController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int { faculties.count }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BaseCell.reuseIdentifier, for: indexPath
        ) as? BaseCell else { return UICollectionViewCell() }
        let faculty = faculties[indexPath.row]
        let width = collectionView.bounds.width - 32
        let height = heightForLabel(text: faculty.text, font: R.font.robotoRegular(size: 17)!, width: width) + 16
        cell.configure(title: faculty.text, textAlignment: .center, cornerRadius: height / 4)
        return cell
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
        UserDefaults.standard.link += faculties[indexPath.row].link
        navigationController?.pushViewController(DirectionsController(), animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FacultiesController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let item = faculties[indexPath.item].text
        let height = heightForLabel(text: item, font: R.font.robotoRegular(size: 17)!, width: width) + 32
        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 16, left: 0.0, bottom: 16.0, right: 0.0) }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: 0, height: 0) }
}
