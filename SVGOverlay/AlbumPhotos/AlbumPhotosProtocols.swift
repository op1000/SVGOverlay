//
//  AlbumPhotosProtocols.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import Foundation
import Photos

protocol AlbumPhotosViewModelProtocol: class {
    /// views
    var albumsView: AlbumPhotosViewProtocol? { get set }
    var albumPhotosView: AlbumPhotosViewProtocol? { get set }
    
    /// binder
    var photoList: Binder<[Album.Photo]?> { get set }
    
    /// data
    var album: Albums.Album? { get set }
    
    /// logic
    func configure()
}

protocol AlbumPhotosViewProtocol: class {
    /// view model
    var albumPhotosViewModel: AlbumPhotosViewModelProtocol? { get set }
    var cellData: Album.Photo? { get set }
    
    /// logic
    func configure()
}

// optionls
extension AlbumPhotosViewProtocol {
    var cellData: Album.Photo? {
        get {
            return Album.Photo()
        }
        // swiftlint:disable unused_setter_value
        set {
            // do nothing
        }
        // swiftlint:enable unused_setter_value
    }
    func configure() {}
}
