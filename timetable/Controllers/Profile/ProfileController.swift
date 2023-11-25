//
//  ProfileController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit

enum CellType {
    case base
    case profile
    case switcher
    case theme
    case clearCache
}

struct SettingsData {
    struct Data {
        let title: String
        let image: UIImage
        let type: CellType
    }
    let item: Data
}

final class ProfileController: TTBaseController {
    private var dataSource: [SettingsData] = []
    private let feedbackView = FeedbackView()
    private let versionLabel: TTLabel = {
        let label = TTLabel()
        label.text = Bundle.main.releaseVersionNumber
        label.font = R.font.robotoRegular(size: 7)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private func showConfirmationAlert() {
        let alertController = UIAlertController(title: "Подтверждение", message: "Вы точно хотите очистить кеш?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Очистить", style: .destructive) { (_) in
            let cacheManager = DataCacheManager()
            cacheManager.clearCache()
            self.collectionView.reloadData()
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ProfileController {
    override func setupViews() {
        super.setupViews()
        collectionView.addSubview(versionLabel)
        collectionView.addSubview(feedbackView)
    }
    override func layoutViews() {
        super.layoutViews()
        versionLabel.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 4,
                            left: view.leadingAnchor, paddingLeft: 16,
                            right: view.trailingAnchor, paddingRight: -16)
        versionLabel.setDimensions(height: 20)
        feedbackView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: -8,
                            centerX: collectionView.centerXAnchor)
    }
    override func configureViews() {
        super.configureViews()
        navigationItem.title = App.Strings.profile
        navigationController?.navigationBar.addBottomBorder(with: R.color.separator(), height: 1)
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
        collectionView.register(CacheInfoCell.self, forCellWithReuseIdentifier: CacheInfoCell.reuseIdentifier)
        collectionView.register(InteractiveCell.self, forCellWithReuseIdentifier: InteractiveCell.reuseIdentifier)
        collectionView.register(ToggleCell.self, forCellWithReuseIdentifier: ToggleCell.reuseIdentifier)
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.reuseIdentifier)
        dataSource = [
            .init(item: .init(title: "Фамилия Имя Отчество",
                              image: R.image.person_crop_circle_fill()!,
                              type: .profile)),
            .init(item: .init(title: App.Strings.changeGroup,
                              image: R.image.person_2_gobackward()!,
                              type: .base)),
            .init(item: .init(title: App.Strings.appearance,
                              image: R.image.theme()!,
                              type: .theme)),
            .init(item: .init(title: App.Strings.cacheMode,
                              image: R.image.theme()!,
                              type: .switcher)),
            .init(item: .init(title: App.Strings.clearCache,
                              image: R.image.info_circle()!,
                              type: .clearCache)),
            .init(item: .init(title: App.Strings.exit,
                              image: R.image.rectangle_portrait_and_arrow_forward()!,
                              type: .base)),
            .init(item: .init(title: App.Strings.aboutApp,
                              image: R.image.info_circle()!,
                              type: .base))
        ]
        collectionView.refreshControl = nil
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { dataSource.count }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource[indexPath.row].item
        switch item.type {
        case .profile:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier,
                                                                for: indexPath) as? ProfileCell else
            { return UICollectionViewCell() }
            cell.configure(title: item.title)
            return cell
        case .theme:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InteractiveCell.reuseIdentifier,
                                                                for: indexPath) as? InteractiveCell else
            { return UICollectionViewCell() }
            cell.configure(title: item.title)
            return cell
        case .switcher:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToggleCell.reuseIdentifier,
                                                                for: indexPath) as? ToggleCell else
            { return UICollectionViewCell() }
            cell.configure(title: item.title)
            cell.delegate = self
            return cell
        case .clearCache:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CacheInfoCell.reuseIdentifier,
                                                                for: indexPath) as? CacheInfoCell else
            { return UICollectionViewCell() }
            let cacheSize = DataCacheManager().calculateCacheSize()
            cell.configure(title: item.title, cacheSize: cacheSize)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCell.reuseIdentifier,
                                                                for: indexPath) as? BaseCell else
            { return UICollectionViewCell() }
            cell.configure(title: item.title)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? BaseCell
        cell?.isHighlighted()
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? BaseCell
        cell?.isUnHighlighted()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            UserDefaults.standard.registered = false
            UserDefaults.standard.link = UserDefaults.standard.groupsLink
            DataCacheManager().clearCache()
            
            let vc_1 = FacultiesController()
            let vc_2 = DirectionsController()
            let vc_3 = GroupsTitlesController()
            let vc_4 = GroupsController()
            
            let navVC = UINavigationController(rootViewController: vc_1)
            navVC.setViewControllers([vc_1, vc_2, vc_3, vc_4], animated: false)

            let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScenes?.windows.first?.switchRootViewController(navVC)

        case 4: showConfirmationAlert()
        case 5:
            UserDefaults.standard.registered = false
            UserDefaults.standard.link = "https://timetable.spbu.ru"
            UserDefaults.standard.groupsLink = ""
            DataCacheManager().clearCache()
            let vc = FacultiesController()
            let navVc = NavigationController(rootViewController: vc)
            let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScenes?.windows.first?.switchRootViewController(navVc)
        default: print(#function)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath)
    -> CGSize { indexPath.row == 0 ?
        CGSize(width: collectionView.frame.width - 32, height: 120) :
        CGSize(width: collectionView.frame.width - 32, height: 65) }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int)
    -> UIEdgeInsets { UIEdgeInsets(top: 16, left: 16.0, bottom: 16.0, right: 16.0) }
    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int)
    -> CGSize { CGSize(width: collectionView.frame.width, height: 0) }
}
