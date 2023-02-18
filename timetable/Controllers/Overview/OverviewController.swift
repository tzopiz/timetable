//
//  OverviewController.swift
//  WorkoutApp
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

class OverviewController: TTBaseController {

    private let navBar = OverviewNavBar()
    private let header = SectionHeaderView()
    private let lectionsList: [TrainingCellView] = {
        var cell = [TrainingCellView]()
        for i in 0..<5 {
            let c = TrainingCellView()
            cell.append(c)
        }
        return cell
    }()
    
}

extension OverviewController {
    override func setupViews() {
        super.setupViews()

        view.setupView(navBar)
        view.setupView(header)
        for i in 0..<lectionsList.count{
            view.setupView(lectionsList[i])
        }
    }

    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            header.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            header.heightAnchor.constraint(equalToConstant: 32),

            
            lectionsList[0].topAnchor.constraint(equalTo: header.bottomAnchor),
            lectionsList[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lectionsList[0].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lectionsList[0].heightAnchor.constraint(equalToConstant: 75)
        ])
        for i in 1..<lectionsList.count {
            NSLayoutConstraint.activate([
                lectionsList[i].topAnchor.constraint(equalTo: lectionsList[i - 1].bottomAnchor, constant: 7),
                lectionsList[i].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                lectionsList[i].trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                lectionsList[i].heightAnchor.constraint(equalToConstant: 75)
            ])
        }
    }

    override func configureAppearance() {
        super.configureAppearance()
        
        navigationController?.navigationBar.isHidden = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let currentDateString: String = dateFormatter.string(from: Date())

        header.configure(with: "\(currentDateString)")
        
        for i in 0..<lectionsList.count{
            lectionsList[i].configure(with: "Лекция", subtitle: "Математический анализ", teacher: "Бочкарёв Анатолий Олегович", classroom: "Университеский проспект, д 35, 208")
            lectionsList[i].layoutIfNeeded()
            lectionsList[i].roundCorners([.bottomRight, .bottomLeft], radius: 5)
        }

    }
}
