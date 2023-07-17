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
    private let versionLabel = UILabel()
}

extension ProfileController {
    override func setupViews() {
        super.setupViews()
        collectionView.addSubview(versionLabel)
    }
    override func constraintViews() {
        super.constraintViews()
        versionLabel.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: -8,
                            left: view.leadingAnchor, paddingLeft: 16,
                            right: view.trailingAnchor, paddingRight: -16)
        versionLabel.setDimensions(height: 20)
    }
    override func configureAppearance() {
        super.configureAppearance()
        navigationItem.title = App.Strings.profile
        navigationController?.navigationBar.addBottomBorder(with: App.Colors.separator, height: 1)
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.ProfileCellId)
        collectionView.register(AppearenceCell.self, forCellWithReuseIdentifier: AppearenceCell.AppearenceCellId)
        collectionView.register(BaseCell.self, forCellWithReuseIdentifier: BaseCell.baseId)
        dataSource = [
            .init(item: .init(title: "Фамилия Имя Отчество",  image: App.Images.imageProfile, type: .profile)),
            .init(item: .init(title: App.Strings.changeGroup, image: App.Images.changeGroup,  type: .base)),
            .init(item: .init(title: App.Strings.appearance,  image: App.Images.theme,        type: .theme)),
            .init(item: .init(title: App.Strings.exit,        image: App.Images.exit,         type: .exit)),
            .init(item: .init(title: App.Strings.aboutApp,    image: App.Images.aboutApp,     type: .base))
        ]
        versionLabel.text = Bundle.main.releaseVersionNumber
        versionLabel.font = App.Fonts.helveticaNeue(with: 10)
        versionLabel.textColor = App.Colors.text
        versionLabel.textAlignment = .center
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
                withReuseIdentifier: ProfileCell.ProfileCellId,
                for: indexPath) as? ProfileCell
            else { return UICollectionViewCell() }
            cell.configure(title: item.title, type: item.type, image: item.image)
            return cell
        case .theme:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AppearenceCell.AppearenceCellId,
                for: indexPath) as? AppearenceCell
            else { return UICollectionViewCell() }
            cell.configure(title: item.title, type: item.type, image: item.image)
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BaseCell.baseId,
                for: indexPath) as? BaseCell
            else { return UICollectionViewCell() }
            cell.configure(title: item.title, type: item.type, image: item.image)
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
        case 3:
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
