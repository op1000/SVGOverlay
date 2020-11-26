//
//  NavigationFactoryProtocols.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

public protocol NavigationFactoryProtocol: NSObjectProtocol {
    /// logic
    var leftBarButtonItems: [UIBarButtonItem]? { get }
    var rightBarButtonItems: [UIBarButtonItem]? { get }
    var leftBarButtons: [UIButton]? { get }
    var rightBarButtons: [UIButton]? { get }
    var titleView: NavigationTitleProtocol? { get }
}

public protocol NavigationTitleProtocol: NSObjectProtocol {
}

public protocol NavigationFactoryReveiverProtocol: NSObjectProtocol {
}
