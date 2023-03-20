//
//  OverviewController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

struct TimatableData {
    struct Data {
        let title: String
        let subtitle: String
        let teacherNS: String
        let time: String
    }
    let date: Date
    let items: [Data]
}

final class OverviewController: TTBaseController {
    private var dataSource: [TimatableData] = []
    private let navBar = OverviewNavBar()
}
extension OverviewController {
    override func setupViews() {
        super.setupViews()
        view.setupView(navBar)
    }

    override func constraintViews() {

        navBar.anchor(top: view.topAnchor,
                      left: view.leadingAnchor,
                      right: view.trailingAnchor)

        collectionView.anchor(top: view.topAnchor,
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

        dataSource = [
            .init(date: Date(timeInterval: 0, since: .now - 60*60*24),
                  items: [
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00"),
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00"),
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00")
                  ]),
            .init(date: Date(timeInterval: 0, since: .now),
                  items: [
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00"),
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00"),
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00")
                  ]),
            .init(date: Date(timeInterval: 0, since: .now + 1*60*60*24),
                  items: [
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00"),
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00"),
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00")
                  ]),
            .init(date: Date(timeInterval: 0, since: .now + 2*60*60*24),
                  items: [
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00"),
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00"),
                    .init(title: "Название, лекция/пркатика",
                          subtitle: "адресс, номер аудитории",
                          teacherNS: "Ф.И.О преподавателя",
                          time: "00:00")
                  ])
        ]
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension OverviewController {
    func numberOfSections(in collectionView: UICollectionView)
    -> Int { dataSource.count }
    override func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int)
    -> Int { dataSource[section].items.count }
    override func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimetableCell.reuseID, for: indexPath
        ) as? TimetableCell else { return UICollectionViewCell() }

        let item = dataSource[indexPath.section].items[indexPath.row]
        cell.configure(with: item.title, subtitle: item.subtitle, teacherNS: item.teacherNS, time: item.time)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: SectionHeaderView.id,
                                                                         for: indexPath) as? SectionHeaderView
        else { return UICollectionReusableView() }
        
        if indexPath.section != 0 {
            view.configure(with: dataSource[indexPath.section].date)
        } else {
            view.configure()
        }
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OverviewController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize { CGSize(width: collectionView.frame.width - 32, height: 120) }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return  UIEdgeInsets(top: 100.0, left: 16.0, bottom: 0.0, right: 16.0)
        }
        if section == dataSource.count - 1 {
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)
        } else {
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        }
    }
}
