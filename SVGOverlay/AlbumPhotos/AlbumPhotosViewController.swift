//
//  AlbumPhotosViewController.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit
import Photos

class AlbumPhotosViewController: UIViewController {
    // MARK: - MVVM
    
    var albumPhotosViewModel: AlbumPhotosViewModelProtocol?
    var albumsViewModel: AlbumsViewModelProtocol?
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var _collectionView: UICollectionView!
    
    // MARK: - Constants
    
    private enum Layout {
        static let numberOfCellsInARow: CGFloat = 3.0
        static let sideMargin: CGFloat = 16.0
        static let interCellMargin: CGFloat = 8.0
    }
    
    // MARK: - Properties - private
    
    private var _list: [Album.Photo] = []
    
    // MARK: - life cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Log.l(l: .i)
    }
    
    deinit {
        Log.l(l: .i)
    }
}

// MARK: - UIViewController

extension AlbumPhotosViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Private

extension AlbumPhotosViewController {
    private func _initializeSettings() {
        _bindDatas()
        albumPhotosViewModel?.configure()
    }
    
    private func _initializeUi() {
        title = albumPhotosViewModel?.album?.title
    }
    
    private func _bindDatas() {
        guard let albumPhotosViewModel = albumPhotosViewModel else {
            return
        }
        albumPhotosViewModel.photoList.bind { [weak self] list in
            guard let self = self, let list = list else { return }
            Log.l(l: .i)
            self._list = list
            self._collectionView.reloadData()
        }
    }
}

// MARK: - AlbumPhotosViewProtocol

extension AlbumPhotosViewController: AlbumPhotosViewProtocol {
    func configure() {
        _initializeSettings()
        _initializeUi()
    }
}

// MARK: - AlbumsViewProtocol

extension AlbumPhotosViewController: AlbumsViewProtocol {
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension AlbumPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _list.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(PhotoCollectionViewCell.self, for: indexPath) else {
            assert(false, "PhotoCollectionViewCell is not resgistered to collectionView")
            return UICollectionViewCell()
        }
        cell.albumPhotosViewModel = albumPhotosViewModel
        cell.cellData = _list[indexPath.row]
        cell.configure()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.bounds.size.width - (Layout.sideMargin * 2) - (Layout.interCellMargin * (Layout.numberOfCellsInARow - 1))) / Layout.numberOfCellsInARow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Log.l(l: .i)
    }
}
