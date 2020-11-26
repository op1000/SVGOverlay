//
//  AlbumsViewController.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import UIKit
import Photos

class AlbumsViewController: UIViewController {
    // MARK: - MVVM
    
    var albumsViewModel: AlbumsViewModelProtocol?
    var albumPhotosViewModel: AlbumPhotosViewModelProtocol?
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var _tableView: UITableView!
    
    // MARK: - Constants
    
    private enum Constants {
        static let moveToAlbumPhotosSegueID = "MoveToAlbumPhotos"
    }
    
    // MARK: - Properties - private
    
    private var _list: [Albums.Album] = []
    
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

extension AlbumsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Navigation

extension AlbumsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.moveToAlbumPhotosSegueID,
            let albumDetail = segue.destination as? AlbumsViewProtocol & AlbumPhotosViewProtocol,
            let album = sender as? Albums.Album {
            // mvvm - for album
            albumDetail.albumsViewModel = albumsViewModel
            self.albumsViewModel?.albumPhotosView = albumDetail
            
            // mvvm - for album photo list
            let viewModel = AlbumPhotosViewModel()
            viewModel.albumsView = self
            viewModel.albumPhotosView = albumDetail
            viewModel.album = album
            albumDetail.albumPhotosViewModel = viewModel
        }
    }
}

// MARK: - Private

extension AlbumsViewController {
    private func _initializeSettings() {
        guard let albumsViewModel = albumsViewModel else {
            return
        }
        _bindDatas()
        albumsViewModel.configure()
    }
    
    private func _initializeUi() {
        title = NSLocalizedString("Albums", comment: "")
    }
    
    private func _bindDatas() {
        guard let albumsViewModel = albumsViewModel else {
            return
        }
        albumsViewModel.userAlbumList.bind { [weak self] list in
            guard let self = self, let list = list else { return }
            Log.l(l: .i)
            self._list = list
            self._tableView.reloadData()
        }
    }
}

// MARK: - AlbumsViewProtocol

extension AlbumsViewController: AlbumsViewProtocol {
    func configure() {
        _initializeSettings()
        _initializeUi()
    }
    
    func showNoAccessAlert() {
        let title = NSLocalizedString("No Photo Access", comment: "")
        let message = NSLocalizedString("Please grant SVGOverlay photo access in Settings -> Privacy", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:])
            }
        })
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - AlbumPhotosViewProtocol

extension AlbumsViewController: AlbumPhotosViewProtocol {
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AlbumsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AlbumTableViewCell = tableView.dequeue(AlbumTableViewCell.self, for: indexPath) else {
            assert(false, "AlbumTableViewCell is not resgistered to tableview")
            return UITableViewCell()
        }
        cell.albumsViewModel = albumsViewModel
        cell.cellData = _list[indexPath.row]
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = _list[indexPath.row]
        performSegue(withIdentifier: Constants.moveToAlbumPhotosSegueID, sender: item)
    }
}
