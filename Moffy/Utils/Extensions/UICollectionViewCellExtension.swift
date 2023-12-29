//
//  UICollectionViewCellExtension.swift
//  Moffy
//
//  Created by macbook on 14/12/2023.
//

import UIKit

extension UICollectionViewCell {
    func getIndexpath() -> IndexPath? {
        guard let collectionView = nearestAncestor(ofType: UICollectionView.self) else {
            return nil
        }
        return collectionView.indexPath(for: self)
    }
}
