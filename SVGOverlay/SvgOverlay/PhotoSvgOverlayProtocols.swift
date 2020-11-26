//
//  PhotoSvgOverlayProtocols.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import Foundation

import Photos

protocol PhotoSvgOverlayViewModelProtocol: class {
    /// views
    var overlayView: PhotoSvgOverlayViewProtocol? { get set }
    
    /// data
    var photo: Album.Photo? { get set }
    var icons: Binder<[PhotoSvg.Overlay]> { get }
    
    /// logic
    func configure()
    func overlay(icon: PhotoSvg.Overlay, iconSize: CGSize)
}

protocol PhotoSvgOverlayViewProtocol: class {
    /// view model
    var photoSvgOverlayViewModel: PhotoSvgOverlayViewModelProtocol? { get set }
    var cellData: PhotoSvg.Overlay? { get set }
    
    /// logic
    func configure()
    func originalPhotoImageViewSize() -> CGSize
    func showImageSaveErrorAlert(error: Error)
    func showImageSavedAlert()
}

// optionls
extension PhotoSvgOverlayViewProtocol {
    var cellData: PhotoSvg.Overlay? {
        get {
            return PhotoSvg.Overlay()
        }
        // swiftlint:disable unused_setter_value
        set {
            // do nothing
        }
        // swiftlint:enable unused_setter_value
    }
    func configure() {}
    func originalPhotoImageViewSize() -> CGSize { return CGSize.zero }
    func showImageSaveErrorAlert(error: Error) {}
    func showImageSavedAlert() {}
}
