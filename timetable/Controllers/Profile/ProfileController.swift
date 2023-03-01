//
//  ProfileController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit
enum cellType {
    case base
    case profile
}
struct SettingsData {
    struct Data {
        let title: String
        let image: UIImage
        let type: cellType
    }
    let item: Data
}

class ProfileController: TTBaseController {

    private var dataSource: [SettingsData] = []
    private enum PresentationStyle: String, CaseIterable {
        case table
    }
    private var selectedStyle: PresentationStyle = .table {
        didSet { updatePresentationStyle() }
    }
    private var styleDelegates: [PresentationStyle: CollectionViewSelectableItemDelegate] = {
        let result: [PresentationStyle: CollectionViewSelectableItemDelegate] = [
            .table: CustomCollectionViewDelegate(),
        ]
        return result
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear

        return view
    }()
    private func updatePresentationStyle(){
        collectionView.delegate = styleDelegates[selectedStyle]
        collectionView.performBatchUpdates({
            collectionView.reloadData()
        }, completion: nil)
    }
    
    
}

extension ProfileController {
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePresentationStyle()
    }
    
    override func setupViews() {
        super.setupViews()
        view.setupView(collectionView)
        collectionView.contentInset = .zero
    }

    override func constraintViews() {
        super.constraintViews()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

    override func configureAppearance() {
        super.configureAppearance()
        title = App.Strings.NavBar.profile

        collectionView.register(SettingsCellView.self, forCellWithReuseIdentifier: SettingsCellView.reuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.performBatchUpdates({
            collectionView.reloadData()
        }, completion: nil)
        dataSource = [
            .init(item: .init(title: "Корчагин Дмитрий Сергеевич", image: App.Images.Profile.imageProfile!, type: .profile)),
            .init(item: .init(title: App.Strings.Settings.changeGroup, image: App.Images.Profile.changeGroup!, type: .base)),
            .init(item: .init(title: App.Strings.Settings.appearance, image: App.Images.Profile.appearance!, type: .base)),
            .init(item: .init(title: App.Strings.Settings.share, image: App.Images.Profile.share!, type: .base)),
            .init(item: .init(title: App.Strings.Settings.feedback, image: App.Images.Profile.feedback!, type: .base)),
            .init(item: .init(title: App.Strings.Settings.aboutApp,  image: App.Images.Profile.aboutApp!, type: .base)),
            .init(item: .init(title: "soon", image: UIImage(), type: .base)),
            .init(item: .init(title: "soon", image: UIImage(), type: .base)),
            .init(item: .init(title: "soon",  image: UIImage(), type: .base))
            

        ]
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension ProfileController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsCellView.reuseID,
                                                            for: indexPath) as? SettingsCellView else {
            fatalError("Wrong cell")
        }
        let item = dataSource[indexPath.row].item
        cell.configure(title: item.title, type: item.type, image: item.image, roundedType: .all)
        return cell
    }
}
