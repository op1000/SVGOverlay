//
//  AlbumsProtocols.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import Foundation
import Photos

protocol AlbumsViewModelProtocol: class {
    /// views
    var albumsView: AlbumsViewProtocol? { get set }
    
    /// binder
    var userAlbumList: Binder<[Albums.Album]?> { get set }
    
    /// logic
    func configure()
}

protocol AlbumsViewProtocol: class {
    /// view model
    var albumsViewModel: AlbumsViewModelProtocol? { get set }
    var cellData: Albums.Album? { get set }
    
    /// logic
    func configure()
    func showNoAccessAlert()
}

// optionls
extension AlbumsViewProtocol {
    var cellData: Albums.Album? {
        get {
            return Albums.Album(title: "")
        }
        // swiftlint:disable unused_setter_value
        set {
            // do nothing
        }
        // swiftlint:enable unused_setter_value
    }
    func configure() {}
    func showNoAccessAlert() {}
}
