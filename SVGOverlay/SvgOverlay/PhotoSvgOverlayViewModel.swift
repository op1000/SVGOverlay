//
//  PhotoSvgOverlayViewModel.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit
import Photos

class PhotoSvgOverlayViewModel: NSObject {
    // MARK: - PhotoSvgOverlayViewModelProtocol
    
    var overlayView: PhotoSvgOverlayViewProtocol?
    var exportSizeChangeView: PhotoSvgOverlayViewProtocol?
    
    // MARK: - Propeties - public
    
    var photo: Album.Photo?
    var icons: Binder<[PhotoSvg.Overlay]> {
        // swiftlint:disable force_unwrapping multiline_literal_brackets indentation_width
        let array = [PhotoSvg.Overlay(icon: UIImage(named: "overlay-cup")!),
                     PhotoSvg.Overlay(icon: UIImage(named: "overlay-donut")!),
                     PhotoSvg.Overlay(icon: UIImage(named: "overlay-icecream")!),
                     PhotoSvg.Overlay(icon: UIImage(named: "overlay-bowl-spoon")!),
                     PhotoSvg.Overlay(icon: UIImage(named: "overlay-beer")!),
                     PhotoSvg.Overlay(icon: UIImage(named: "overlay-vegitables")!),
                     PhotoSvg.Overlay(icon: UIImage(named: "overlay-bowl-chicken-potato")!),
                     PhotoSvg.Overlay(icon: UIImage(named: "overlay-cake")!),
                     PhotoSvg.Overlay(icon: UIImage(named: "overlay-rib")!)
        ]
        // swiftlint:enable force_unwrapping multiline_literal_brackets indentation_width
        return Binder(array)
    }
    
    var overlaidImage: UIImage? {
        return _internalOverlaidImage
    }
    
    // MARK: - Propeties - private
    
    private var _internalOverlaidImage: UIImage?
    
    // MARK: - Propeties - factory
    
    private let _imageManager = PHCachingImageManager()
    
    // MARK: - life cycle
    
    override init() {
        Log.l(l: .i)
    }
    
    deinit {
        Log.l(l: .i)
        _unConfigure()
    }
}

// MARK: - Private

extension PhotoSvgOverlayViewModel {
    private func _unConfigure() {
    }
    
    private func _fetchOriginalImage() {
        guard let photoAsset = photo?.asset else {
            return
        }
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }
            
            // fetch full size image
            self._imageManager.requestImage(for: photoAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { image, _ in
                Log.l("image.size = \(image?.size ?? CGSize.zero)")
                self.photo?.thumbnail.value = image
            }
        }
    }
}

// MARK: - PhotoSvgOverlayViewModelProtocol

extension PhotoSvgOverlayViewModel: PhotoSvgOverlayViewModelProtocol {
    func configure() {
        _fetchOriginalImage()
    }
    
    func overlay(icon: PhotoSvg.Overlay, iconSize: CGSize, completion: @escaping (UIImage) -> Void) {
        guard let orgImage = photo?.thumbnail.value, let topImage = icon.icon.value else {
            return
        }
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            let orgSize = orgImage.size
            
            UIGraphicsBeginImageContextWithOptions(orgSize, false, 0.0)
            
            orgImage.draw(in: CGRect(origin: CGPoint.zero, size: orgSize))
            let startPoint = CGPoint(x: (orgSize.width - iconSize.width) / 2.0, y: (orgSize.height - iconSize.height) / 2.0)
            topImage.draw(in: CGRect(origin: startPoint, size: iconSize))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self._internalOverlaidImage = newImage
            
            if let newImage = newImage {
                OperationQueue.main.addOperation {
                    completion(newImage)
                }
            }
        }
    }
    
    func saveImagePhotoLibrary(image: UIImage) {
        let selector = #selector(self.processAfterImageSaved(_:error:contextInfo:))
        image.saveToPhotoLibrary(self, selector)
    }
    
    func resetOverlay() {
        _internalOverlaidImage = nil
    }
    
    func resizeOverlaidImage(size: CGSize, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self, let orgImage = self._internalOverlaidImage, let newImage = orgImage.resize(size.width, size.height) else {
                return
            }
            Log.l("newImageSie = \(newImage.size), change size = \(size), org size = \(orgImage.size)")
            OperationQueue.main.addOperation {
                completion(newImage)
            }
        }
    }
    
    func closeSizeChangeView() {
        overlayView?.closeSizeChangeView()
    }
}

// MARK: - Actions/Selectors

extension PhotoSvgOverlayViewModel {
    @objc private func processAfterImageSaved(_ image: UIImage, error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            overlayView?.showImageSaveErrorAlert(error: error)
        } else {
            overlayView?.showImageSavedAlert()
        }
    }
}
