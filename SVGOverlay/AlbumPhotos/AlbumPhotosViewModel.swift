//
//  AlbumPhotosViewModel.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import Foundation
import Photos

class AlbumPhotosViewModel: NSObject {
    // MARK: - AlbumPhotosViewModelProtocol
    
    weak var albumPhotosView: AlbumPhotosViewProtocol?
    
    // MARK: - Propeties - public
    
    var album: Albums.Album?
    var photoList: Binder<[Album.Photo]?> = Binder(nil)
    
    // MARK: - Propeties - factory
    
    private let _imageManager = PHCachingImageManager()
    
    private let _requestOptions: PHImageRequestOptions = {
        let opt = PHImageRequestOptions()
        opt.isNetworkAccessAllowed = true
        opt.resizeMode = .fast
        return opt
    }()
    
    private let _fetchOptions: PHFetchOptions = {
        let opt = PHFetchOptions()
        opt.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
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

extension AlbumPhotosViewModel {
    private func _configurePhotosList() {
        var photoList: [Album.Photo] = []
        let assetsFetchResults: PHFetchResult<PHAsset>
        if let album = album?.asset {
            assetsFetchResults = PHAsset.fetchAssets(in: album, options: _fetchOptions)
        } else {
            // all photos
            assetsFetchResults = PHAsset.fetchAssets(with: _fetchOptions)
        }
        for index in 0..<assetsFetchResults.count {
            let photo = assetsFetchResults[index]
            let uiPhoto = Album.Photo(asset: photo)
            photoList.append(uiPhoto)
            OperationQueue.main.addOperation { [weak self] in
                guard let self = self else { return }
                self._imageManager.requestImage(for: photo, targetSize: Album.Layout.thumbnailSize, contentMode: .aspectFill, options: self._requestOptions) { image, _ in
                    uiPhoto.thumbnail.value = image
                }
            }
        }
        self.photoList.value = photoList
    }
    
    private func _unConfigure() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

// MARK: - AlbumPhotosViewModelProtocol

extension AlbumPhotosViewModel: AlbumPhotosViewModelProtocol {
    func configure() {
        PHPhotoLibrary.shared().register(self)
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }
            self._configurePhotosList()
        }
    }
}

// MARK: - PHPhotoLibraryChangeObserver

extension AlbumPhotosViewModel: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        Log.l(l: .i)
        // NOTE: 리스트 동적 변경 테스트는 스크린샷을 찍으면 됨, 사진을 찍으면 앱이 강제 종료 됨
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }
            self._configurePhotosList()
        }
    }
}
