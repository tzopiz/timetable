//
//  OverviewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

final class OverviewController: TTBaseController {
    
    private let navBar = OverviewNavBar()
    private let backgroundView = BackgroundTimetableOverview()
    
    private let cacheManager = DataCacheManager()
    private var timetableData: StudyWeek?
    
    private func loadData(completion: @escaping (StudyWeek) -> Void) {
        cacheManager.loadTimetableData(with: navBar.getFirstDay()) { [weak self] studyWeek, err in
            guard self != nil else { return }
            if let studyWeek = studyWeek { completion(studyWeek) }
            else { completion(StudyWeek(startDate: "", days: []))}
        }
    }
    // Метод обновления UICollectionView и обработки данных
    private func updateCollectionView(with studyWeek: StudyWeek?) {
        guard let studyWeek = studyWeek else { return }
        print(#function)
        // Обновление данных в UICollectionView и интерфейсе
        self.timetableData = studyWeek
        self.navBar.updateButtonTitle(with: studyWeek.startDate)
        self.updateBackgroundView(value: self.timetableData?.days.count ?? 0)
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    @IBAction func refreshData() {
        // Показываем индикатор загрузки (UIRefreshControl)
        self.collectionView.refreshControl?.beginRefreshing()

        // Загружаем данные из кеша
        cacheManager.getDownloadedTimetable(with: navBar.getFirstDay()) { [weak self] cachedData in
            if let cachedData = cachedData {
                // Если данные из кеша доступны, обновляем коллекцию с ними
                self?.updateCollectionView(with: cachedData)
                // Завершаем обновление (скрытие индикатора загрузки)
                self?.collectionView.refreshControl?.endRefreshing()
            } else {
                // Если данных в кеше нет, загружаем с сервера
                self?.loadData() { [weak self] studyWeek in
                    DispatchQueue.main.async {
                        // После получения данных с сервера, обновляем коллекцию
                        self?.updateCollectionView(with: studyWeek)
                        // Завершаем обновление (скрытие индикатора загрузки)
                        self?.collectionView.refreshControl?.endRefreshing()
                    }
                }
            }
        }
    }
}

extension OverviewController {
    override func setupViews() {
        super.setupViews()
        view.setupView(navBar)
        view.setupView(backgroundView)
    }
    override func constraintViews() {
        navBar.anchor(top: view.topAnchor,
                      left: view.leadingAnchor,
                      right: view.trailingAnchor)
        
        collectionView.anchor(top: navBar.bottomAnchor,
                              bottom: view.bottomAnchor,
                              left: view.leadingAnchor,
                              right: view.trailingAnchor)
        backgroundView.anchor(left: view.leadingAnchor, paddingLeft: 16,
                              right: view.trailingAnchor, paddingRight: -16,
                              centerY: view.centerYAnchor, centerX: view.centerXAnchor)
    }
    override func configureAppearance() {
        super.configureAppearance()
        navigationController?.navigationBar.isHidden = true
        
        collectionView.register(TimetableCell.self,
                                forCellWithReuseIdentifier: TimetableCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        backgroundView.isHidden = true
        backgroundView.configure(height: view.bounds.height / 3, width: view.bounds.width - 32)
        
        navBar.completionUpdate = { [weak self] index in
            self?.refreshData()
            if let index = index { // TODO: Scroll to day not to index
                if !(self?.timetableData?.days.isEmpty ?? true) { self?.scrollToDay(with: index) }
            }
        }
        
        let rightSwipe = UISwipeGestureRecognizer(target: self,action: #selector(rightSwipeWeek))
        rightSwipe.direction = .right
        collectionView.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self,action: #selector(leftSwipeWeek))
        leftSwipe.direction = .left
        collectionView.addGestureRecognizer(leftSwipe)
        navBar.toToday()
    }
}

// MARK: - UICollectionViewDataSource

extension OverviewController {
    func numberOfSections(in collectionView: UICollectionView)
    -> Int { timetableData?.days.count ?? 0 }
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int)
    -> Int { timetableData?.days[section].lessons.count ?? 0 }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimetableCell.reuseIdentifier, for: indexPath
        ) as? TimetableCell else { return UICollectionViewCell() }
        
        guard let item = timetableData?.days[indexPath.section].lessons[indexPath.row] else { return cell }
        cell.configure(time: item.time, nameSubject: item.name, location: item.location, teacherName: item.teacher, isCancelled: item.isCancelled)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                                                                         for: indexPath) as? SectionHeaderView
        else { return UICollectionReusableView() }
        view.configure(with: timetableData?.days[indexPath.section].date ?? "")
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OverviewController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32 // Adjusted width (collectionView width minus 32 points)
        guard let item = timetableData?.days[indexPath.section].lessons[indexPath.row] else { return CGSize(width: 0, height: 0) }
        // TODO: бывает плохо считает высоту и кучу warning насчет ambigious high
        let timeLabelHeight = heightForLabel(text: item.time, font: App.Fonts.helveticaNeue(with: 15), width: width)
        let nameLabelHeight = heightForLabel(text: item.name, font: App.Fonts.helveticaNeue(with: 17), width: width)
        let locationLabelHeight = heightForLabel(text: item.location, font: App.Fonts.helveticaNeue(with: 13), width: width)
        let teacherLabelHeight = heightForLabel(text: item.teacher, font: App.Fonts.helveticaNeue(with: 13), width: width)
        let totalHeight = timeLabelHeight + nameLabelHeight + locationLabelHeight + teacherLabelHeight + 40
        return CGSize(width: width, height: totalHeight)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let days = timetableData?.days else { return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0) }
        if section == days.count - 1 { return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0) }
        else { return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0) }
    }
}

extension OverviewController {
    private func scrollToDay(with index: Int) {
        if collectionView.dataSource?.collectionView(self.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) != nil {
            guard let timetableData = timetableData else { return }
            if index < timetableData.days.count {
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
    private func updateBackgroundView(value: Int) {
        backgroundView.updateImage()
        backgroundView.isHidden = value == 0 ? false : true
    }
    // TODO: normal animate swipe collection view and navbar
    @IBAction func rightSwipeWeek() { navBar.rightSwipeWeek() }
    @IBAction func leftSwipeWeek() { navBar.leftSwipeWeek() }
}
