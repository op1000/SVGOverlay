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
    weak var albumsPhotosView: AlbumsViewProtocol?
    
    // MARK: - Propeties - public
    
    var userAlbumList: Binder<[Albums.Album]?> = Binder(nil)
    
    // MARK: - Propeties - private
    
    private var _userAlbums: PHFetchResult<PHAssetCollection>?
    private var _smartAlbums: PHFetchResult<PHAssetCollection>?
    private let _imageManager = PHCachingImageManager()
    
    // MARK: - Properties - factory
    
    private let _requestOptions: PHImageRequestOptions = {
        let opt = PHImageRequestOptions()
        opt.isNetworkAccessAllowed = true
        opt.resizeMode = .fast
        return opt
    }()
    
    // MARK: - life cycle
    
    init(defaultUuid: String? = nil) {
        Log.l(l: .i)
    }
    
    deinit {
        Log.l(l: .i)
    }
}

// MARK: - Private

extension AlbumsViewModel {
    private func _requestPhotosAuthorization() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async { [weak self] in
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
        
        _configureAllPhotosAlbum(&userAlbumList)
        _configureUserAlbums(&userAlbumList)
        _configureSmartAlbums(&userAlbumList)
        
        self.userAlbumList.value = userAlbumList
    }
    
    private func _configureAllPhotosAlbum(_ container: inout [Albums.Album]) {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let assetsFetchResults = PHAsset.fetchAssets(with: options)
        if let firstPhoto = assetsFetchResults.firstObject {
            let uiAlbum = Albums.Album(title: NSLocalizedString("All Photos", comment: ""))
            container.append(uiAlbum)
            _imageManager.requestImage(for: firstPhoto, targetSize: Albums.Layout.thumbnailSize, contentMode: .aspectFill, options: _requestOptions) { image, _ in
                uiAlbum.thumbnail.value = image
            }
        }
    }
    
    private func _configureUserAlbums(_ container: inout [Albums.Album]) {
        guard let userAlbums = _userAlbums, userAlbums.isEmpty == false else {
            return
        }
        for index in 0..<userAlbums.count {
            let album = userAlbums[index]
            guard let title = album.localizedTitle else {
                continue
            }
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let assetsFetchResults = PHAsset.fetchAssets(in: album, options: options)
            if let firstPhoto = assetsFetchResults.firstObject {
                let uiAlbum = Albums.Album(title: title)
                container.append(uiAlbum)
                _imageManager.requestImage(for: firstPhoto, targetSize: Albums.Layout.thumbnailSize, contentMode: .aspectFill, options: _requestOptions) { image, _ in
                    uiAlbum.thumbnail.value = image
                }
            }
        }
    }
    
    private func _configureSmartAlbums(_ container: inout [Albums.Album]) {
        guard let smartAlbums = _smartAlbums, smartAlbums.isEmpty == false else {
            return
        }
        for index in 0..<smartAlbums.count {
            let album = smartAlbums[index]
            guard let title = album.localizedTitle else {
                continue
            }
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let assetsFetchResults = PHAsset.fetchAssets(in: album, options: options)
            if let firstPhoto = assetsFetchResults.firstObject {
                let uiAlbum = Albums.Album(title: title)
                container.append(uiAlbum)
                _imageManager.requestImage(for: firstPhoto, targetSize: Albums.Layout.thumbnailSize, contentMode: .aspectFill, options: _requestOptions) { image, _ in
                    uiAlbum.thumbnail.value = image
                }
            }
        }
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let userAlbums = self._userAlbums, let changes = changeInstance.changeDetails(for: userAlbums) {
                self._userAlbums = changes.fetchResultAfterChanges
                self._configureAlbumList()
            }
        }
    }
}
