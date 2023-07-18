//
//  TeacherController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 17.07.2023.
//

import UIKit

final class TeacherController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    private let contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = App.Colors.separator.cgColor
        return imageView
    }()
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    private let rightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    private let nameLabel = TTLabel(fontSize: 20)
    private let positionLabel = TTLabel()
    private let additionalInfoLabel = TTLabel()
    private let linksLabel = TTLabel()
    private var teacherInfo: TeacherInfo!
    var link: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        constraintViews()
        configureAppearence()
    }
}
extension TeacherController {
    func setupViews() {
        view.setupView(scrollView)
        scrollView.setupView(contentView)
        contentView.addArrangedSubview(nameLabel)
        contentView.addArrangedSubview(topStackView)
        contentView.addArrangedSubview(linksLabel)
        
        topStackView.addArrangedSubview(photoImageView)
        topStackView.addArrangedSubview(rightStackView)
        
        rightStackView.addArrangedSubview(positionLabel)
        rightStackView.addArrangedSubview(additionalInfoLabel)
    }
    
    func constraintViews() {
        
        scrollView.anchor(top: view.topAnchor,
                          bottom: view.bottomAnchor,
                          left: view.leadingAnchor,
                          right: view.trailingAnchor)
        contentView.anchor(top: scrollView.topAnchor, paddingTop: 16,
                           bottom: scrollView.bottomAnchor, paddingBottom: -16,
                           left: scrollView.leadingAnchor, paddingLeft: 16,
                           right: scrollView.trailingAnchor, paddingRight: -16)
        photoImageView.setDimensions(height: 200, width: 150)
    }
    
    func configureAppearence() {
        view.backgroundColor = App.Colors.background
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        APIManager.shared.fetchTeacherInfo(link: link) { [weak self] teacherInfo in
            guard let self = self else { return }
            self.teacherInfo = teacherInfo
            nameLabel.text = teacherInfo.name
            positionLabel.text = teacherInfo.position
            additionalInfoLabel.text = teacherInfo.additionalInfo
            linksLabel.text = teacherInfo.links.joined(separator: "\n")
            for section in teacherInfo.sections {
                let labelTextView = LabelTextView()
                labelTextView.configure(title: section.title, text: section.items.joined(separator: "\n"))
                contentView.addArrangedSubview(labelTextView)
            }
            APIManager.shared.getImageURL(from: link) { urlImage in
                guard let urlImage = urlImage else { return }
                APIManager.shared.loadImage(from: urlImage) { image in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.photoImageView.image = image
                            self.contentView.setDimensions(width: self.scrollView.frame.width - 32)
                        }
                    } else { print("Изображение не найдено или произошла ошибка при загрузке.") }
                }
            }
            
        }
        
    }
}
