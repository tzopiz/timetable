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
    
    override func refreshData() {
        // Показываем индикатор загрузки (UIRefreshControl)
        self.collectionView.refreshControl?.beginRefreshing()
        
        cacheManager.getDownloadedTimetable(with: navBar.getFirstDay()) { [weak self] cachedData in
            guard let self = self else { return }
            if let cachedData = cachedData {
                // Если данные из кеша доступны, обновляем коллекцию с ними
                DispatchQueue.main.async {
                    self.updateCollectionView(with: cachedData)
                    // Завершаем обновление (скрытие индикатора загрузки)
                    self.collectionView.refreshControl?.endRefreshing()
                }
            }
            // Загружаем данные с сервера
            loadData() { [weak self] studyWeek in
                guard let self = self else { return }
                if studyWeek != cachedData {
                    DispatchQueue.main.async {
                        self.updateCollectionView(with: studyWeek)
                        // Завершаем обновление (скрытие индикатора загрузки)
                        self.collectionView.refreshControl?.endRefreshing()
                    }
                }
            }
        }
    }
    
    private func loadData(completion: @escaping (StudyWeek) -> Void) {
        cacheManager.loadTimetableData(with: navBar.getFirstDay()) { [weak self] studyWeek, err in
            guard self != nil else { return }
            if let studyWeek = studyWeek { completion(studyWeek) }
            else { completion(StudyWeek(startDate: "Что-то сломалось.🙈", days: []))}
        }
    }
    
    private func updateCollectionView(with studyWeek: StudyWeek?) {
        guard let studyWeek = studyWeek else { return }
        
        timetableData = studyWeek
        animateImageAppearance(shouldAppear: (timetableData?.days.count ?? 0) == 0)
        navBar.updateButtonTitle(with: studyWeek.startDate)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
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
        backgroundView.anchor(centerY: view.centerYAnchor, centerX: view.centerXAnchor)
    }
    override func configureAppearance() {
        super.configureAppearance()
        navigationController?.isNavigationBarHidden = true
        
        collectionView.register(TimetableCell.self,
                                forCellWithReuseIdentifier: TimetableCell.reuseIdentifier)
        collectionView.register(BaseCell.self,
                                forCellWithReuseIdentifier: BaseCell.reuseIdentifier)
        collectionView.register(SectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionView.reuseIdentifier)
        
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        backgroundView.isHidden = true
        backgroundView.configure(height: view.bounds.height / 3, width: view.bounds.width - 32)
        
        navBar.swipeCompletion = { [weak self] direction in
            guard let self = self else { return }
            self.animateSwipe(to: direction)
        }
        navBar.scrollCompletion = { [weak self] index in
            guard let self = self, let isEmpty = self.timetableData?.days.isEmpty else { return }
            if !isEmpty { self.scrollToDay(with: index) }
        }
        
        let backSwipe = UISwipeGestureRecognizer(target: self,action: #selector(backSwipeWeek))
        backSwipe.direction = .right
        collectionView.addGestureRecognizer(backSwipe)
        
        let forwardSwipe = UISwipeGestureRecognizer(target: self,action: #selector(forwardSwipeWeek))
        forwardSwipe.direction = .left
        collectionView.addGestureRecognizer(forwardSwipe)
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
        guard let lesson = timetableData?.days[indexPath.section].lessons[indexPath.row]
        else { return UICollectionViewCell() }
        if lesson.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BaseCell.reuseIdentifier, for: indexPath
            ) as? BaseCell else { return UICollectionViewCell() }
            cell.configure(title: "Занятий нет", textAlignment: .center)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TimetableCell.reuseIdentifier, for: indexPath
            ) as? TimetableCell else { return UICollectionViewCell() }
            
            cell.configure(time: lesson.time, nameSubject: lesson.name, location: lesson.location, teacherName: lesson.teacher, isCancelled: lesson.isCancelled)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionView.reuseIdentifier,
                                                                         for: indexPath) as? SectionView
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
        // TODO: heap warnings ambigious high
        let timeLabelHeight = heightForLabel(text: item.time, font: App.Fonts.helveticaNeue(with: 15), width: width - 32)
        let nameLabelHeight = heightForLabel(text: item.name, font: App.Fonts.helveticaNeue(with: 17), width: width - 32)
        let locationLabelHeight = heightForLabel(text: item.location, font: App.Fonts.helveticaNeue(with: 13), width: width - 32)
        let teacherLabelHeight = heightForLabel(text: item.teacher, font: App.Fonts.helveticaNeue(with: 13), width: width - 32)
        let totalHeight = timeLabelHeight + nameLabelHeight + locationLabelHeight + teacherLabelHeight + 24 + 16
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

// MARK: - Animation

extension OverviewController {
    private func scrollToDay(with index: Int) {
        guard let timetableData = timetableData else { return }
        if index < timetableData.days.count {
            let headerHeight = collectionView.collectionViewLayout
                .layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                      at: IndexPath(item: 0, section: index))?.frame.height ?? 0
            let yOffset = collectionView
                .layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader,
                                                         at: IndexPath(item: 0, section: index))?.frame.origin.y ?? 0 - headerHeight
            DispatchQueue.main.async { self.collectionView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true) }
        } else { scrollCollectionViewToTop() }
    }
    
    func animateImageAppearance(shouldAppear: Bool) {
        switch shouldAppear {
        case true:
            self.backgroundView.isHidden = false
            self.backgroundView.updateImage()
            TTBaseView.animate(withDuration: 0.2, animations: {
                self.backgroundView.transform = .identity
            })
        case false:
            TTBaseView.animate(withDuration: 0.2, animations: {
                self.backgroundView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }) { _ in
                self.backgroundView.isHidden = true
            }
        }
    }
    
    private func animateSwipe(to direcet: WeekView.SwipeDirections) {
        animanteSwipeCollectionView(to: direcet)
        navBar.swipeWeekView(to: direcet)
    }
    @IBAction func forwardSwipeWeek() { animateSwipe(to: .forward) }
    @IBAction func backSwipeWeek() { animateSwipe(to: .back) }
    
    private func animanteSwipeCollectionView(to direct: WeekView.SwipeDirections) {
        switch direct {
        case .back:
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.transform = CGAffineTransform(translationX: self.collectionView.frame.width, y: 0)
                self.collectionView.alpha = 0.5
            }) { _ in
                self.collectionView.alpha = 0
                self.refreshData()
                self.collectionView.transform = CGAffineTransform(translationX: -self.collectionView.frame.width, y: 0)
                UIView.animate(withDuration: 0.4, animations: {
                    self.collectionView.transform = .identity
                    self.collectionView.alpha = 1.0
                })
            }
        case .forward:
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.transform = CGAffineTransform(translationX: -self.collectionView.frame.width, y: 0)
                self.collectionView.alpha = 0.5
            }) { _ in
                self.collectionView.alpha = 0
                self.refreshData()
                self.collectionView.transform = CGAffineTransform(translationX: self.collectionView.frame.width, y: 0)
                UIView.animate(withDuration: 0.4, animations: {
                    self.collectionView.transform = .identity
                    self.collectionView.alpha = 1.0
                })
            }
        }
    }
}
