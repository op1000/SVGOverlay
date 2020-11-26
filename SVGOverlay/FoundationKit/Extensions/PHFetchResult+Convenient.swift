//
//  PHFetchResult+Convenient.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import Foundation
import Photos

// swiftlint:disable empty_count

extension PHFetchResult {
    @objc var isEmpty: Bool {
        return count == 0
    }
}

// swiftlint:enable empty_count
