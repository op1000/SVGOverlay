//
//  AlbumsProtocols.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import Foundation

protocol AlbumsViewModelProtocol {
    /// views
    var albumsView: AlbumsViewProtocol? { get set }
    var albumsPhotosView: AlbumsViewProtocol? { get set }
    
    /// binder
    var userAlbumList: Binder<[Albums.Album]?> { get set }
    
    /// logic
    func configure()
}

protocol AlbumsViewProtocol: class {
    /// view model
    var albumsViewModel: AlbumsViewModelProtocol? { get set }
    
    /// logic
    func configure()
    func showNoAccessAlert()
}

// optionls
extension AlbumsViewProtocol {
    func configure() {}
    func showNoAccessAlert() {}
}
