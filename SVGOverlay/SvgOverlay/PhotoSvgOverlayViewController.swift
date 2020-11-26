//
//  PhotoSvgOverlayViewController.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

class PhotoSvgOverlayViewController: UIViewController {
    // MARK: - MVVM
    
    var photoSvgOverlayViewModel: PhotoSvgOverlayViewModelProtocol?
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var _collectionView: UICollectionView!
    @IBOutlet private weak var _overlayView: UIView!
    @IBOutlet private weak var _overlayIconImageView: UIImageView!
    @IBOutlet private weak var _originalPhotoImageView: UIImageView!
    
    // MARK: - Properties - private
    
    private var _list: [PhotoSvg.Overlay] = []
    
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

extension PhotoSvgOverlayViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Private

extension PhotoSvgOverlayViewController {
    private func _initializeSettings() {
        _bindDatas()
        photoSvgOverlayViewModel?.configure()
    }
    
    private func _initializeUi() {
    }
    
    private func _bindDatas() {
        guard let photoSvgOverlayViewModel = photoSvgOverlayViewModel else {
            return
        }
        photoSvgOverlayViewModel.photo?.thumbnail.bind { [weak self] image in
            guard let self = self else { return }
            self._originalPhotoImageView.image = image
        }
        photoSvgOverlayViewModel.icons.bind { [weak self] list in
            guard let self = self else { return }
            self._list = list
            self._collectionView.reloadData()
        }
    }
}

// MARK: - PhotoSvgOverlayViewProtocol

extension PhotoSvgOverlayViewController: PhotoSvgOverlayViewProtocol {
    func configure() {
        _initializeSettings()
        _initializeUi()
    }
    
    func originalPhotoImageViewSize() -> CGSize {
        return _originalPhotoImageView.frame.size
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PhotoSvgOverlayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _list.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(OverlayIconCollectionViewCell.self, for: indexPath) else {
            assert(false, "PhotoCollectionViewCell is not resgistered to collectionView")
            return UICollectionViewCell()
        }
        cell.photoSvgOverlayViewModel = photoSvgOverlayViewModel
        cell.cellData = _list[indexPath.row]
        cell.configure()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = _list[indexPath.row]
        _overlayIconImageView.image = item.icon.value
        _overlayIconImageView.isHidden = false
    }
}
