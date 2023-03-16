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

class OverviewController: TTBaseController {
    
    private var dataSource: [TimatableData] = []
    
    private let navBar = OverviewNavBar()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear

        return view
    }()
    
}
extension OverviewController {
    override func setupViews() {
        super.setupViews()

        view.setupView(navBar)
        view.setupView(collectionView)
        
    }

    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }

    override func configureAppearance() {
        super.configureAppearance()
                
        navigationController?.navigationBar.isHidden = true

        collectionView.register(TimetableCell.self,
                                forCellWithReuseIdentifier: TimetableCell.reuseID)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.id)

        collectionView.delegate = self
        collectionView.dataSource = self


        dataSource = [
            .init(date: Date(timeInterval: 60*60*24, since: .now),
                  items: [
                    .init(title: "Математический анализ, лекция", subtitle: "Университетский проспект, д. 35, лит. Д, 208Д", teacherNS: "Бочкарёв А. О.", time: "13:40–15:15"),
                    .init(title: "Теория функции коплексной переменной, лекция", subtitle: "Университетский проспект, д. 35, лит. Д, 208Д", teacherNS: "Распопова Н. В.", time: "15:25–17:00"),
                  ]),
            .init(date: Date(timeInterval: 0, since: .now),
                  items: [
                    .init(title: "Математический анализ, пркатика", subtitle: "Университетский проспект, д. 35, лит. Д, 208Д", teacherNS: "Бочкарёв А. О.", time: "11:15–12:50"),
                    .init(title: "Математический анализ, лекция", subtitle: "Университетский проспект, д. 35, лит. Д, 208Д", teacherNS: "Бочкарёв А. О.", time: "13:40–15:15"),
                    .init(title: "Теория функции коплексной переменной, практика", subtitle: "Университетский проспект, д. 35, лит. Д, 208Д", teacherNS: "Распопова Н. В.", time: "15:25–17:00"),
                  ]),
            .init(date: Date(timeInterval: -60*60*24, since: .now),
                  items: [
                    .init(title: "Математический анализ, пркатика", subtitle: "Университетский проспект, д. 35, лит. Д, 212Д", teacherNS: "Бочкарёв А. О.", time: "11:15–12:50"),
                    .init(title: "Теория функции коплексной переменной, лекция", subtitle: "Университетский проспект, д. 35, лит. Д, 212Д", teacherNS: "Распопова Н. В.", time: "13:40–15:15"),
                    .init(title: "Теория функции коплексной переменной, пркатика", subtitle: "Университетский проспект, д. 35, лит. Д, 212Д", teacherNS: "Распопова Н. В.", time: "15:25–17:00"),
                  ]),
            .init(date: Date(timeInterval: -2*60*60*24, since: .now),
                  items: [
                    .init(title: "Траектория 3 (В1 – В2). Английский язык, практическое занятие", subtitle: "Университетский проспект, д. 35, лит. Д, 210Д", teacherNS: "Соболев И. А.", time: "11:15–12:50"),
                    .init(title: "Траектория 3 (В1 – В2). Английский язык, практическое занятие", subtitle: "Университетский проспект, д. 35, лит. Д, 210Д", teacherNS: "Соболев И. А.", time: "13:40–15:15"),
                    .init(title: "Траектория 3 (В1 – В2). Английский язык, практическое занятие", subtitle: "Университетский проспект, д. 35, лит. Д, 210Д", teacherNS: "Соболев И. А.", time: "15:25–17:00"),
                  ]),
            .init(date: Date(timeInterval: -3*60*60*24, since: .now),
                  items: [
                    .init(title: "Дифференциальные уравнения, практическое занятие", subtitle: "Университетский проспект, д. 35, лит. Д, 208Д", teacherNS: "Ногин В. Д.", time: "11:15–12:50"),
                    .init(title: "Теория функции коплексной переменной, практическое занятие", subtitle: "Университетский проспект, д. 35, лит. Д, 208Д", teacherNS: "Распопова Н. В.", time: "13:40–15:15"),
                    .init(title: "Теоретическая механика, практическое занятие", subtitle: "Университетский проспект, д. 35, лит. Д, 208Д", teacherNS: "Пупышева Ю. Ю.", time: "15:25–17:00"),
                  ]),
            .init(date: Date(timeInterval: -4*60*60*24, since: .now),
                  items: [
                    .init(title: "Дифференциальные уравнения, лекция", subtitle:"Университетский проспект, д. 35, лит. Д, 208Д", teacherNS: "Ногин В. Д.", time: "15:25–17:00"),
                  ])
        ]
        collectionView.reloadData()
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        for cell in self.collectionView.visibleCells {
            let c = (cell as? TimetableCell)!
            c.borderLayer.fillColor = App.Colors.BlackWhite.cgColor
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OverviewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        dataSource.count
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        dataSource[section].items.count
        
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimetableCell.reuseID, for: indexPath
        ) as? TimetableCell else { return UICollectionViewCell() }

        let item = dataSource[indexPath.section].items[indexPath.row]
        cell.configure(with: item.title, subtitle: item.subtitle,teacherNS: item.teacherNS ,time: item.time)
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
extension OverviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: collectionView.frame.width, height: 120)
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        CGSize(width: collectionView.frame.width, height: 32)
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == dataSource.count - 1 {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 16.0, right: 0.0)
        } else {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 8
    }
}
