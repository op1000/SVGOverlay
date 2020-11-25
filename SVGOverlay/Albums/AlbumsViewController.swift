//
//  AlbumsViewController.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import UIKit

class AlbumsViewController: UIViewController {
    // MARK: - MVVM
    var albumsViewModel: AlbumsViewModelProtocol?
}

// MARK: - UIViewController

extension AlbumsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _initializeSettings()
        _initializeUi()
    }
}

// MARK: - Private

extension AlbumsViewController {
    private func _initializeSettings() {
        guard let albumsViewModel = albumsViewModel else {
            return
        }
        albumsViewModel.userAlbumList.bind(listener: { [weak self] list in
            guard let self = self else { return }
            guard list != nil else { return }
            Log.l(l: .i)
        })
        albumsViewModel.configure()
    }
    
    private func _initializeUi() {
    }
}

// MARK: - AlbumsViewProtocol

extension AlbumsViewController: AlbumsViewProtocol {
}
