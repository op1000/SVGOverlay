//
//  PhotoSvgOverlayDataStructures.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

// swiftlint:disable convenience_type

struct PhotoSvg {
    struct Overlay {
        var thumbnail: UIImage?
        var icon: Binder<UIImage?> = Binder(nil)
        
        init(thumbnail: UIImage) {
            Log.l(l: .i)
            self.thumbnail = thumbnail
        }
        
        init(icon: UIImage) {
            Log.l(l: .i)
            self.icon.value = icon
        }
        
        init() {
            Log.l(l: .i)
        }
    }
}

// swiftlint:enable convenience_type
