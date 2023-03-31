//
//  OverviewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class OverviewController: TTBaseController {
    private let navBar = OverviewNavBar()
    private var dataSource: [StudyDay] = []
}
extension OverviewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        navBar.completionUpdate = { [weak self] dateStr in
            guard let self = self else { return }
            APIManager.shared.getTimetable(with: dateStr) { [weak self] dates, title in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.dataSource = dates
                    if self.dataSource.count == 0 {
                        self.dataSource.append(StudyDay(date: self.navBar.getFirstDay(),
                                                        lessons:
                                [StudyDay.Lesson(time: "",
                                                 nameSubject: "Занятий нет",
                                                 address: "",
                                                 teacherName: "")
                                ]))
                    }
                    self.collectionView.refreshControl?.endRefreshing()
                    self.collectionView.reloadData()
                    self.navBar.updateButtonTitle(with: title)
                }
            }
        }
        navBar.completionScroll = { [weak self] index in
            guard let self = self else { return }
            if self.collectionView.dataSource?.collectionView(self.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) != nil {
                if index != 0 {
                    var calculatedOffset: CGFloat = 0
                    if index < self.dataSource.count {
                        for i in 0..<index {
                            calculatedOffset += 32
                            calculatedOffset += CGFloat(135 * (self.dataSource[i].lessons.count))
                            calculatedOffset += CGFloat(8 * (self.dataSource[i].lessons.count - 1))
                        }
                        self.collectionView.setContentOffset(CGPoint(x: 0, y: calculatedOffset), animated: true)
                    } else {
                        self.scrollCollectionViewToTop()
                    }
                }
            }
        }
        let rightSwipe = UISwipeGestureRecognizer(target: self,action: #selector(rightSwipeWeek))
        rightSwipe.direction = .right
        collectionView.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self,action: #selector(leftSwipeWeek))
        leftSwipe.direction = .left
        collectionView.addGestureRecognizer(leftSwipe)
    }
    // TODO: normal animate swipe collection view and navbar
    @objc func rightSwipeWeek() {
        navBar.rightSwipeWeek()
    }
    @objc func leftSwipeWeek() {
        navBar.leftSwipeWeek()
    }
    
    @objc func refreshData() {
        self.collectionView.refreshControl?.beginRefreshing()
        if let isRefreshing = self.collectionView.refreshControl?.isRefreshing, isRefreshing {
            APIManager.shared.getTimetable(
                with: navBar.getFirstDay()) { [weak self] dates, title in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.dataSource = dates
                        self.collectionView.refreshControl?.endRefreshing()
                        self.collectionView.reloadData()
                        self.navBar.updateButtonTitle(with: title)
                    }
            }
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
        cell.configure(time: item.time, nameSubject: item.nameSubject, address: item.address, teacherName: item.teacherName)
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
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize { CGSize(width: collectionView.frame.width - 32, height: 135) }

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
