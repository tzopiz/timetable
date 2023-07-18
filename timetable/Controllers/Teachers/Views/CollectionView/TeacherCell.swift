//
//  TeacherCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.07.2023.
//

import UIKit

class TeacherCell: BaseCell {
    
    static let reuseIdentifier = String(describing: TeacherCell.self)
    
    private let nameLabel = TTLabel(fontSize: 19)
    private let positionLabel = TTLabel(fontSize: 17)
    private let departmentLabel = TTLabel(fontSize: 17)
    private let publicationsLabel = TTLabel(textColor: App.Colors.text_2, fontSize: 17)
    private let applicationsLabel = TTLabel(textColor: App.Colors.text_2, fontSize: 17)
    private let grantsLabel = TTLabel(textColor: App.Colors.text_2, fontSize: 17)
    private let projectsLabel = TTLabel(textColor: App.Colors.text_2, fontSize: 17)
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        return stackView
    }()
    private var personalLink: String = ""
    
    var personalLinkButtonTappedHandler: ((String) -> Void)?
    
    func configure(with teacher: Teacher) {
        nameLabel.text = teacher.name
        positionLabel.text = teacher.position
        departmentLabel.text = teacher.department
        publicationsLabel.text = "Publications: \(teacher.publications)"
        applicationsLabel.text = "Applications: \(teacher.applications)"
        grantsLabel.text = "Grants: \(teacher.grants)"
        projectsLabel.text = "Projects: \(teacher.projects)"
        personalLink = teacher.personalLink
    }
    
    @IBAction func personalLinkButtonTapped() {
        personalLinkButtonTappedHandler?("link") // open next VC
    }
}

extension TeacherCell {
    override func setupViews() {
        contentView.setupView(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(positionLabel)
        stackView.addArrangedSubview(departmentLabel)
        stackView.addArrangedSubview(publicationsLabel)
        stackView.addArrangedSubview(applicationsLabel)
        stackView.addArrangedSubview(grantsLabel)
        stackView.addArrangedSubview(projectsLabel)
    }
    override func constraintViews() {
        stackView.anchor(top: contentView.topAnchor, paddingTop: 16,
                         bottom: contentView.bottomAnchor, paddingBottom: -16,
                         left: contentView.leadingAnchor, paddingLeft: 16,
                         right: contentView.trailingAnchor, paddingRight: -16)
    }
    override func configureAppearance() {
        layer.cornerRadius = 16
        backgroundColor = App.Colors.BlackWhite
    }
}
