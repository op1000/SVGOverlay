//
//  AlbumPhotosDataStructures.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit
import Photos

// swiftlint:disable convenience_type

struct Album {
    struct Photo {
        var thumbnail: Binder<UIImage?> = Binder(nil)
        var asset: PHAsset?
        
        init(asset: PHAsset) {
            Log.l(l: .i)
            self.asset = asset
        }
        
        init() {
            Log.l(l: .i)
        }
    }
    
    enum Layout {
        static let thumbnailSize = CGSize(width: 104.0 * UIScreen.main.scale, height: 104.0 * UIScreen.main.scale)
    }
}

// swiftlint:enable convenience_type
