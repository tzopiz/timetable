//
//  OverviewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}

final class OverviewController: TTBaseController {
    private let navBar = OverviewNavBar()
    private var dataSource: [StudyDay] = []
}
extension OverviewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupViews() {
        super.setupViews()
        view.setupView(navBar)
    }
    override func constraintViews() {

        navBar.anchor(top: view.topAnchor,
                      left: view.leadingAnchor,
                      right: view.trailingAnchor)

        collectionView.anchor(top: navBar.bottomAnchor,
                              bottom: view.bottomAnchor,
                              left: view.leadingAnchor,
                              right: view.trailingAnchor)
    }

    override func configureAppearance() {
        super.configureAppearance()
        navigationController?.navigationBar.isHidden = true

        collectionView.register(TimetableCell.self,
                                forCellWithReuseIdentifier: TimetableCell.reuseID)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.id)
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        navBar.completionUpdate = { [weak self] dateStr, index in
            guard let self = self else { return }
            APIManager.shared.loadData(with: dateStr) { [weak self] data in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.dataSource = data.days
                    if self.dataSource.count == 0 {
                        self.dataSource.append(StudyDay(
                            date: self.navBar.getFirstDay(),
                            lessons: [Lesson(time: "", name: "Пары отсутствуют", location: " ", teacher: "")]))
                        
                    }
                    self.collectionView.refreshControl?.endRefreshing()
                    self.collectionView.reloadData()
                    self.navBar.updateButtonTitle(with: data.startDate)
                    if let index = index {
                        if !self.dataSource.isEmpty {
                            self.scrollToDay(with: index)
                        }
                    }
                }
            }
        }
        navBar.completionScroll = { [weak self] index in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if !self.dataSource.isEmpty {
                    self.scrollToDay(with: index)
                }
            }
        }
        
        let rightSwipe = UISwipeGestureRecognizer(target: self,action: #selector(rightSwipeWeek))
        rightSwipe.direction = .right
        collectionView.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self,action: #selector(leftSwipeWeek))
        leftSwipe.direction = .left
        collectionView.addGestureRecognizer(leftSwipe)
        refreshData()
    }
    // TODO: normal animate swipe collection view and navbar
    @IBAction func rightSwipeWeek() { navBar.rightSwipeWeek() }
    @IBAction func leftSwipeWeek() { navBar.leftSwipeWeek() }
    @IBAction func refreshData() {
        self.collectionView.refreshControl?.beginRefreshing()
        if let isRefreshing = self.collectionView.refreshControl?.isRefreshing, isRefreshing {
            APIManager.shared.loadData(
                with: navBar.getFirstDay()) { [weak self] data in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.dataSource = data.days
                        self.navBar.updateButtonTitle(with: data.startDate)
                        self.collectionView.reloadData()
                    }
            }
        }
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    func scrollToDay(with index: Int) {
        if collectionView.dataSource?.collectionView(self.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) != nil {
            if index < self.dataSource.count {
                // Получаем высоту UICollectionReusableView
                let headerHeight = collectionView.collectionViewLayout
                    .layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                          at: IndexPath(item: 0, section: index))?.frame.height ?? 0
                let yOffset = collectionView
                    .layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader,
                                                             at: IndexPath(item: 0, section: index))?.frame.origin.y ?? 0 - headerHeight
                collectionView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            } else { scrollCollectionViewToTop() }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension OverviewController {
    
    func numberOfSections(in collectionView: UICollectionView)
    -> Int { dataSource.count }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int)
    -> Int { dataSource[section].lessons.count }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimetableCell.reuseID, for: indexPath
        ) as? TimetableCell else { return UICollectionViewCell() }
        
        let item = dataSource[indexPath.section].lessons[indexPath.row]
        cell.configure(time: item.time, nameSubject: item.name, location: item.location, teacherName: item.teacher, isCancelled: item.isCancelled)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionHeaderView.id,
                                                                         for: indexPath) as? SectionHeaderView
        else { return UICollectionReusableView() }

        view.configure(with: dataSource[indexPath.section].date)
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OverviewController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        let item = dataSource[indexPath.section].lessons[indexPath.row]
        
        let timeLabelHeight = heightForLabel(text: item.time, font: App.Fonts.helveticaNeue(with: 15), width: width)
        let nameLabelHeight = heightForLabel(text: item.name, font: App.Fonts.helveticaNeue(with: 17), width: width)
        let locationLabelHeight = heightForLabel(text: item.location, font: App.Fonts.helveticaNeue(with: 13), width: width)
        let teacherLabelHeight = heightForLabel(text: item.teacher, font: App.Fonts.helveticaNeue(with: 13), width: width)
        
        let totalHeight = timeLabelHeight + nameLabelHeight + locationLabelHeight + teacherLabelHeight + 40 // Сумма высот всех компонентов в ячейке
        
        return CGSize(width: width, height: totalHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == dataSource.count - 1 {
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)
        } else {
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        }
    }
}
