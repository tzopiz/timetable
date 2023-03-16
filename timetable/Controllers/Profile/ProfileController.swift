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
    case exit
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
    
    private let untiBag = UIView(frame: .zero)
    
    private var dataSource: [SettingsData] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear

        return view
    }()
    
}

extension ProfileController {
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(untiBag)
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
        
        addNavBarButton(at: .right, with: "darkMode")
        
        title = App.Strings.NavBar.profile
        
        self.untiBag.isHidden = true

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseID)
  
        dataSource = [
            .init(item: .init(title: "Фамилия Имя Отчество", image: App.Images.Profile.imageProfile, type: .profile)),
            .init(item: .init(title: App.Strings.Profile.changeGroup, image: App.Images.Profile.changeGroup, type: .base)),
            .init(item: .init(title: App.Strings.Profile.share, image: App.Images.Profile.share, type: .base)),
            .init(item: .init(title: App.Strings.Profile.feedback, image: App.Images.Profile.feedback, type: .base)),
            .init(item: .init(title: "soon", image: UIImage(), type: .base)),
            .init(item: .init(title: "soon", image: UIImage(), type: .base)),
            .init(item: .init(title: App.Strings.Profile.exit,  image: App.Images.Profile.exit, type: .exit)),
            .init(item: .init(title: App.Strings.Profile.aboutApp,  image: App.Images.Profile.aboutApp, type: .base))

        ]
        collectionView.reloadData()
    }
    override func navBarRightButtonHandler() {
        if #available(iOS 13.0, *) {
            UserDefaults.standard.theme = App.Theme(rawValue: 2 - UserDefaults.standard.theme.getUserInterfaceStyle().rawValue ) ?? .device
            view.window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.getUserInterfaceStyle()
        }
        
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension ProfileController: UICollectionViewDataSource, UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseID,
                                                            for: indexPath) as? ProfileCell else {
            fatalError("Wrong cell")
        }
        let item = dataSource[indexPath.row].item
        cell.configure(title: item.title, type: item.type, image: item.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCell
        cell.isHighlighted()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCell
        cell.isUnHighlighted()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UserDefaults.standard.theme = .device
//        view.window?.overrideUserInterfaceStyle = UserDefaults.standard.theme.getUserInterfaceStyle()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize: CGSize
        let sectionInsets = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 0.0, right: 0.0)
        let itemWidth = collectionView.bounds.width - (sectionInsets.left + sectionInsets.right)
        itemSize = indexPath.item == 0 ? CGSize(width: itemWidth, height: 120) : CGSize(width: itemWidth, height: 65)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 16
    }
}
