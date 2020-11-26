//
//  AlbumsDataStructures.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import UIKit
import Photos

// swiftlint:disable convenience_type

struct Albums {
    struct Album {
        let title: String
        var asset: PHAssetCollection?
        var thumbnail: Binder<UIImage?> = Binder(nil)
        
        init(title: String) {
            self.title = title
        }
    }
    
    enum Layout {
        static let thumbnailSize = CGSize(width: 64.0 * UIScreen.main.scale, height: 64.0 * UIScreen.main.scale)
    }
}

// swiftlint:enable convenience_type
