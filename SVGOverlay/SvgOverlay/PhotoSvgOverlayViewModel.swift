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
    
    // MARK: - Propeties - factory
    
    private let _imageManager = PHCachingImageManager()
    
    private let _requestOptions: PHImageRequestOptions = {
        let opt = PHImageRequestOptions()
        opt.isNetworkAccessAllowed = true
        opt.resizeMode = .fast
        return opt
    }()
    
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
        guard let photoAsset = photo?.asset, let size = overlayView?.originalPhotoImageViewSize() else {
            return
        }
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }
            
            self._imageManager.requestImage(for: photoAsset, targetSize: size, contentMode: .aspectFill, options: self._requestOptions) { image, _ in
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
}
