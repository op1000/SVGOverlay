//
//  CollectionView+Cell.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

public extension UICollectionView {
    func dequeue<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as? T
    }
}
