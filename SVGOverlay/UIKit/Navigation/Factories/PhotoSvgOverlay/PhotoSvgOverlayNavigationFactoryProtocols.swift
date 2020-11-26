//
//  PhotoSvgOverlayNavigationFactoryProtocols.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

public protocol PhotoSvgOverlayNavigationFactoryProtocol: NavigationFactoryProtocol {
    /// views
    var view: PhotoSvgOverlayNavigationFactoryReveiverProtocol? { get }
}

public protocol PhotoSvgOverlayNavigationTitleProtocol: NavigationTitleProtocol {
}

public protocol PhotoSvgOverlayNavigationFactoryReveiverProtocol: NavigationFactoryReveiverProtocol {
    func isOverlayIconVisible() -> Bool
    func currentUserInterfaceStyle() -> UIUserInterfaceStyle
    func actionCloseButtonPressed(_ sender: UIButton)
    func actionOverlayButtonPressed(_ sender: UIButton)
}
