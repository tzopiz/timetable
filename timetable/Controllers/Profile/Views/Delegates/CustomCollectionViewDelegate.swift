//
//  CustomCollectionViewDelegate.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.03.2023.
//


import UIKit


class CustomCollectionViewDelegate: DefaultCollectionViewDelegate {
    
    private let itemsPerRow: CGFloat = 3
    private let minimumItemSpacing: CGFloat = 8
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize: CGSize
        if indexPath.item == 0 {
            let itemWidth = collectionView.bounds.width - (sectionInsets.left + sectionInsets.right)
            itemSize = CGSize(width: itemWidth, height: 112)
        } else {
            let itemWidth = collectionView.bounds.width - (sectionInsets.left + sectionInsets.right)
            itemSize = CGSize(width: itemWidth, height: 50)
        }
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemSpacing
    }
}
