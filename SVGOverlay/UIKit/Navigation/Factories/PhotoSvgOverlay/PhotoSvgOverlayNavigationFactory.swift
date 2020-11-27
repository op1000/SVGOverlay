//
//  PhotoSvgOverlayNavigationFactory.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit
import SnapKit

public class PhotoSvgOverlayNavigationFactory: NSObject {
    // MARK: - Properties - PhotoSvgOverlayNavigationFactoryProtocol
    
    public weak var view: PhotoSvgOverlayNavigationFactoryReveiverProtocol?
    
    public var leftBarButtonItems: [UIBarButtonItem]? {
        return _createLeftBarButtonItems()
    }
    public var rightBarButtonItems: [UIBarButtonItem]? {
        return _createRightBarButtonItems()
    }
    public var leftBarButtons: [UIButton]? {
        return _createLeftBarButtons()
    }
    public var rightBarButtons: [UIButton]? {
        return _createRightBarButtons()
    }
    public var titleView: NavigationTitleProtocol? {
        return nil
    }

    // MARK: - life cycle
    
    public override init() {
        Log.l(l: .i)
    }
    
    deinit {
        Log.l(l: .i)
    }
}

// MARK: - Private - creation

extension PhotoSvgOverlayNavigationFactory {
    private func _createLeftBarButtonItems() -> [UIBarButtonItem]? {
        guard let buttons = _createLeftBarButtons() else {
            return nil
        }
        var barbuttons: [UIBarButtonItem] = []
        for button: UIButton in buttons {
            let barButton = UIBarButtonItem(customView: button)
            barbuttons.append(barButton)
        }
        return barbuttons
    }
    
    private func _createRightBarButtonItems() -> [UIBarButtonItem]? {
        guard let buttons = _createRightBarButtons() else {
            return nil
        }
        var barbuttons: [UIBarButtonItem] = []
        for button: UIButton in buttons {
            let barButton = UIBarButtonItem(customView: button)
            barbuttons.append(barButton)
        }
        return barbuttons
    }
    
    private func _createLeftBarButtons() -> [UIButton]? {
        return [_createBackButton()]
    }
    
    private func _createRightBarButtons() -> [UIButton]? {
        if view?.isOverlayIconVisible() == true {
            return [_createOverlayButton()]
        } else {
            return nil
        }
    }
}

// MARK: - Private - buttons

extension PhotoSvgOverlayNavigationFactory {
    private func _createBackButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(actionCloseButtonPressed(_:)), for: .touchUpInside)
        button.snp.makeConstraints(_makeButtonLayout)
        
        var image = UIImage(named: "close")
        if view?.currentUserInterfaceStyle() == .dark {
            image = image?.imageWithColor(color: .white)
        } else {
            image = image?.imageWithColor(color: .black)
        }
        button.setImage(image, for: .normal)
        return button
    }
    
    private func _createOverlayButton() -> UIButton {
        let button = UIButton()
        let titleString = NSLocalizedString("Overlay", comment: "")
        button.setTitle(titleString, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: NavigationFactory.Layout.textButtonLabelFontSize)
        button.addTarget(self, action: #selector(actionOverlayButtonPressed(_:)), for: .touchUpInside)
        button.snp.makeConstraints(_makeOverlayButtonLayout)
        button.layer.cornerRadius = NavigationFactory.Layout.textButtonHeight / 2.0
        button.layer.masksToBounds = true
        
        if view?.currentUserInterfaceStyle() == .dark {
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
        } else {
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
        }
        button.setTitleColor(.gray, for: .disabled)

        return button
    }
    
    private func _makeButtonLayout(_ make: ConstraintMaker) {
        make.width.equalTo(NavigationFactory.Layout.buttonWidth)
        make.height.equalTo(NavigationFactory.Layout.buttonWidth)
    }
    
    private func _makeOverlayButtonLayout(_ make: ConstraintMaker) {
        let titleString = NSLocalizedString("Overlay", comment: "")
        let size: CGSize = titleString.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: NavigationFactory.Layout.titleLabelFontSize)])
        make.width.equalTo(size.width + NavigationFactory.Layout.titleLabelBothSidesMargin)
        make.height.equalTo(NavigationFactory.Layout.textButtonHeight)
    }
}

// MARK: - Actions

extension PhotoSvgOverlayNavigationFactory {
    @objc private func actionCloseButtonPressed(_ sender: UIButton) {
        Log.l(l: .i)
        view?.actionCloseButtonPressed(sender)
    }
    
    @objc private func actionOverlayButtonPressed(_ sender: UIButton) {
        Log.l(l: .i)
        view?.actionOverlayButtonPressed(sender)
    }
}

// MARK: - PhotoSvgOverlayNavigationFactoryProtocol

extension PhotoSvgOverlayNavigationFactory: PhotoSvgOverlayNavigationFactoryProtocol {
}

// MARK: - NavigationFactoryProtocol

extension PhotoSvgOverlayNavigationFactory: NavigationFactoryProtocol {
}
