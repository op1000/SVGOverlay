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
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var _tableView: UITableView!
    
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
        albumsViewModel.userAlbumList.bind { [weak self] list in
            guard let self = self, let list = list else { return }
            Log.l(l: .i)
            self._list = list
            self._tableView.reloadData()
        }
        albumsViewModel.configure()
    }
    
    private func _initializeUi() {
    }
}

// MARK: - AlbumsViewProtocol

extension AlbumsViewController: AlbumsViewProtocol {
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
    }
}
