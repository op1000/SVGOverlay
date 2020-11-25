//
//  AlbumsDataStructures.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import Foundation
import UIKit

struct Albums {
    struct Album {
        let title: String
        var thumbnail: Binder<UIImage?> = Binder(nil)
        
        init(title: String) {
            self.title = title
        }
    }
    
    enum Layout {
        static let thumbnailSize = CGSize(width: 64.0, height: 64.0)
    }
}
