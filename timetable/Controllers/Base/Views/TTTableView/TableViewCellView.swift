//
//  TableViewCellView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.02.2023.
//

import UIKit

class TableViewCellView: TTBaseView {
    
    private let title: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 2
        title.font = App.Fonts.menloRegular(with: 18)
        title.textColor =  App.Colors.titleGray
        return title
    }()
    private let details: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 2
        title.font = App.Fonts.menloRegular(with: 15)
        title.textColor =  App.Colors.inactive
        return title
    }()
    private let date: UILabel = {
        let title = UILabel()
        title.text = ""
        title.numberOfLines = 2
        title.font = App.Fonts.menloRegular(with: 12)
        title.textColor = App.Colors.inactive
        return title
    }()
    private let checkmark: UIImageView = {
        let imageView = UIImageView()
        let image = App.Images.Common.isActiveTask?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = App.Colors.inactive
        imageView.image = image
        return imageView
    }()
    func configureContent(title: String, subtitle: String, details: String) {
        self.title.text = title
        self.details.text = subtitle
        self.date.text = details
    }

    
}
extension TableViewCellView {
    override func setupViews() {
        super.setupViews()
        setupView(title)
        setupView(details)
        setupView(date)
        
    }

    override func constaintViews() {
        super.constaintViews()
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            title.heightAnchor.constraint(equalToConstant: 50),
            
            details.topAnchor.constraint(equalTo: title.bottomAnchor, constant: -7),
            details.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            details.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            details.heightAnchor.constraint(equalToConstant: 50),
            
            date.topAnchor.constraint(equalTo: details.bottomAnchor, constant: -15),
            date.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            date.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            date.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }

    override func configureAppearance() {
        super.configureAppearance()
        
    }
}
