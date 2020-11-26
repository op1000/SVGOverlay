//
//  AlbumsViewModel.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import Foundation
import Photos

class AlbumsViewModel: NSObject {
    // MARK: - AlbumsViewModelProtocol
    
    weak var albumsView: AlbumsViewProtocol?
    
    // MARK: - Propeties - public
    
    var userAlbumList: Binder<[Albums.Album]?> = Binder(nil)
    
    // MARK: - Propeties - private
    
    private var _userAlbums: PHFetchResult<PHAssetCollection>?
    private var _smartAlbums: PHFetchResult<PHAssetCollection>?
    
    // MARK: - Properties - factory
    
    private let _imageManager = PHCachingImageManager()
    
    private let _requestOptions: PHImageRequestOptions = {
        let opt = PHImageRequestOptions()
        opt.isNetworkAccessAllowed = true
        opt.resizeMode = .fast
        return opt
    }()
    
    private let _fetchOptions: PHFetchOptions = {
        let opt = PHFetchOptions()
        opt.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
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

extension AlbumsViewModel {
    private func _requestPhotosAuthorization() {
        PHPhotoLibrary.requestAuthorization { status in
            OperationQueue.main.addOperation { [weak self] in
                guard let self = self else { return }
                switch status {
                case .authorized:
                    self._processPhotoAuthorized()
                default:
                    self._processPhotoAuthorizationDeclined()
                }
            }
        }
    }
    
    private func _processPhotoAuthorized() {
        PHPhotoLibrary.shared().register(self)
        _fetchAlbums()
        _configureAlbumList()
    }
    
    private func _processPhotoAuthorizationDeclined() {
        albumsView?.showNoAccessAlert()
    }
    
    private func _fetchAlbums() {
        guard let albums = PHCollectionList.fetchTopLevelUserCollections(with: nil) as? PHFetchResult<PHAssetCollection> else {
            return
        }
        _userAlbums = albums
        _smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
    }
    
    private func _configureAlbumList() {
        var userAlbumList: [Albums.Album] = []
        
        _configureAddAllPhotosAlbum(&userAlbumList)
        _configureAddUserAlbums(&userAlbumList)
        _configureAddSmartAlbums(&userAlbumList)
        
        self.userAlbumList.value = userAlbumList
    }
    
    private func _configureAddAllPhotosAlbum(_ container: inout [Albums.Album]) {
        let assetsFetchResults = PHAsset.fetchAssets(with: _fetchOptions)
        if let firstPhoto = assetsFetchResults.firstObject {
            var uiAlbum = Albums.Album(title: NSLocalizedString("All Photos", comment: ""))
            uiAlbum.asset = nil
            container.append(uiAlbum)
            _imageManager.requestImage(for: firstPhoto, targetSize: Albums.Layout.thumbnailSize, contentMode: .aspectFill, options: _requestOptions) { image, _ in
                uiAlbum.thumbnail.value = image
            }
        }
    }
    
    private func _configureAddUserAlbums(_ container: inout [Albums.Album]) {
        guard let userAlbums = _userAlbums, userAlbums.isEmpty == false else {
            return
        }
        for index in 0..<userAlbums.count {
            let album = userAlbums[index]
            guard let title = album.localizedTitle else {
                continue
            }
            let assetsFetchResults = PHAsset.fetchAssets(in: album, options: _fetchOptions)
            if let firstPhoto = assetsFetchResults.firstObject {
                var uiAlbum = Albums.Album(title: title)
                uiAlbum.asset = album
                container.append(uiAlbum)
                _imageManager.requestImage(for: firstPhoto, targetSize: Albums.Layout.thumbnailSize, contentMode: .aspectFill, options: _requestOptions) { image, _ in
                    uiAlbum.thumbnail.value = image
                }
            }
        }
    }
    
    private func _configureAddSmartAlbums(_ container: inout [Albums.Album]) {
        guard let smartAlbums = _smartAlbums, smartAlbums.isEmpty == false else {
            return
        }
        for index in 0..<smartAlbums.count {
            let album = smartAlbums[index]
            guard let title = album.localizedTitle else {
                continue
            }
            let assetsFetchResults = PHAsset.fetchAssets(in: album, options: _fetchOptions)
            if let firstPhoto = assetsFetchResults.firstObject {
                var uiAlbum = Albums.Album(title: title)
                uiAlbum.asset = album
                container.append(uiAlbum)
                _imageManager.requestImage(for: firstPhoto, targetSize: Albums.Layout.thumbnailSize, contentMode: .aspectFill, options: _requestOptions) { image, _ in
                    uiAlbum.thumbnail.value = image
                }
            }
        }
    }
    
    private func _unConfigure() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

// MARK: - AlbumsViewModelProtocol

extension AlbumsViewModel: AlbumsViewModelProtocol {
    func configure() {
        _requestPhotosAuthorization()
    }
}

// MARK: - PHPhotoLibraryChangeObserver

extension AlbumsViewModel: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        Log.l(l: .i)
        // NOTE: 리스트 동적 변경 테스트는 스크린샷을 찍으면 됨, 사진을 찍으면 앱이 강제 종료 됨
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }
            if let userAlbums = self._userAlbums, let changes = changeInstance.changeDetails(for: userAlbums) {
                self._userAlbums = changes.fetchResultAfterChanges
                self._configureAlbumList()
            }
        }
    }
}
