//
//  ProfileController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit
import PhotosUI

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
        label.font = App.Fonts.helveticaNeue(with: 7)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private func showConfirmationAlert() {
        let alertController = UIAlertController(title: "Подтверждение", message: "Вы точно хотите очистить кеш?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Очистить", style: .destructive) { (_) in
            let cacheManager = DataCacheManager()
            cacheManager.clearCache()
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
    override func constraintViews() {
        super.constraintViews()
        versionLabel.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 4,
                            left: view.leadingAnchor, paddingLeft: 16,
                            right: view.trailingAnchor, paddingRight: -16)
        versionLabel.setDimensions(height: 20)
        feedbackView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: -8,
                            centerX: collectionView.centerXAnchor)
    }
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = App.Strings.profile
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
        collectionView.register(InteractiveCell.self, forCellWithReuseIdentifier: InteractiveCell.reuseIdentifier)
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.reuseIdentifier)
        dataSource = [
            .init(item: .init(title: "Фамилия Имя Отчество",  image: App.Images.imageProfile, type: .profile)),
            .init(item: .init(title: App.Strings.changeGroup, image: App.Images.changeGroup,  type: .base)),
            .init(item: .init(title: App.Strings.appearance,  image: App.Images.theme,        type: .theme)),
            .init(item: .init(title: "Кешировать расписание",  image: App.Images.theme,       type: .switcher)),
            .init(item: .init(title: App.Strings.clearCache,  image: App.Images.aboutApp,     type: .base)),
            .init(item: .init(title: App.Strings.exit,        image: App.Images.exit,         type: .base)),
            .init(item: .init(title: App.Strings.aboutApp,    image: App.Images.aboutApp,     type: .base))
           
        ]
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
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileCell.reuseIdentifier,
                for: indexPath) as? ProfileCell
            else { return UICollectionViewCell() }
            cell.configure(title: item.title, image: item.image)
            return cell
        case .theme, .switcher:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InteractiveCell.reuseIdentifier,
                for: indexPath) as? InteractiveCell
            else { return UICollectionViewCell() }
            cell.configure(title: item.title, type: item.type)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BaseCell.reuseIdentifier,
                for: indexPath) as? BaseCell
            else { return UICollectionViewCell() }
            cell.configure(title: item.title, type: item.type)
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
    func openImagePickerVC() {  // TODO: read about this
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            openImagePickerVC()
        case 4:
            showConfirmationAlert()
        case 5:
            UserDefaults.standard.registered = false
            UserDefaults.standard.link = "https://timetable.spbu.ru"
            
            let vc = FacultiesController()
            let navVc = NavigationController(rootViewController: vc)
            let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScenes?.windows.first?.switchRootViewController(navVc)
        default:
            print(#function)
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

// MARK: - PHPickerViewControllerDelegate

extension ProfileController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    CoreDataMamanager.shared.saveProfileImage(image)
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}
