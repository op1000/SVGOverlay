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
    
    // MARK: - Constants
    
    private enum Constants {
        static let UnwindToAlbumPhotosSegueID = "UnwindToAlbumPhotos"
    }
    
    // MARK: - Properties - private
    
    private var _list: [PhotoSvg.Overlay] = []
    
    // MARK: - Properties - factory
    
    private lazy var _navigaionFactory: PhotoSvgOverlayNavigationFactory = {
        let navigaionFactory = PhotoSvgOverlayNavigationFactory()
        navigaionFactory.view = self
        return navigaionFactory
    }()
    
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
        _configureNavigaionBar()
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
    
    private func _configureNavigaionBar() {
        title = nil
        navigationItem.leftBarButtonItems = _navigaionFactory.leftBarButtonItems
        navigationItem.rightBarButtonItems = _navigaionFactory.rightBarButtonItems
    }
    
    private func _processOverlayIconSelected(_ overlay: PhotoSvg.Overlay) {
        _overlayIconImageView.image = overlay.icon.value
        _overlayIconImageView.isHidden = false
        _configureNavigaionBar()
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

// MARK: - PhotoSvgOverlayNavigationFactoryReveiverProtocol

extension PhotoSvgOverlayViewController: PhotoSvgOverlayNavigationFactoryReveiverProtocol {
    func actionCloseButtonPressed(_ sender: UIButton) {
        Log.l(l: .i)
        performSegue(withIdentifier: Constants.UnwindToAlbumPhotosSegueID, sender: nil)
    }
    
    func actionOverlayButtonPressed(_ sender: UIButton) {
        Log.l(l: .i)
    }
    
    func currentUserInterfaceStyle() -> UIUserInterfaceStyle {
        return traitCollection.userInterfaceStyle
    }
    
    func isOverlayIconVisible() -> Bool {
        return _overlayIconImageView.isHidden == false
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
        _processOverlayIconSelected(item)
    }
}
