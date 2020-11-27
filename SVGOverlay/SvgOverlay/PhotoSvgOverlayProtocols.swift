//
//  PhotoSvgOverlayProtocols.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

import Photos

protocol PhotoSvgOverlayViewModelProtocol: class {
    /// views
    var overlayView: PhotoSvgOverlayViewProtocol? { get set }
    var exportSizeChangeView: PhotoSvgOverlayViewProtocol? { get set }
    
    /// data
    var photo: Album.Photo? { get set }
    var icons: Binder<[PhotoSvg.Overlay]> { get }
    var overlaidImage: UIImage? { get }
    
    /// logic
    func configure()
    func overlay(icon: PhotoSvg.Overlay, iconSize: CGSize, completion: @escaping (UIImage) -> Void)
    func saveImagePhotoLibrary(image: UIImage)
    func resetOverlay()
    func resizeOverlaidImage(size: CGSize, completion: @escaping (UIImage) -> Void)
    func closeSizeChangeView()
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
    func closeSizeChangeView()
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
    func closeSizeChangeView() {}
}
