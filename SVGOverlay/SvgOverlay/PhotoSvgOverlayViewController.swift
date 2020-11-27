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
    @IBOutlet private weak var _imageExportSizeChangeViewContainer: UIView!
    private weak var _imageExportSizeChangeView: PhotoSvgOverlayViewProtocol?
    
    // MARK: - Constants
    
    private enum Constants {
        static let UnwindToParentSegueID = "UnwindToParent"
        static let EmbedSizeSlierSegueID = "EmbedSizeSlier"
    }
    
    // MARK: - Properties - private
    
    private var _list: [PhotoSvg.Overlay] = []
    private var _selectedIcon: PhotoSvg.Overlay?
    
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

// MARK: - Navigation

extension PhotoSvgOverlayViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.EmbedSizeSlierSegueID, let exportSizeChangeView = segue.destination as? PhotoSvgOverlayViewProtocol {
            // mvvm creation
            let viewModel = photoSvgOverlayViewModel
            viewModel?.exportSizeChangeView = exportSizeChangeView
            exportSizeChangeView.photoSvgOverlayViewModel = viewModel
            _imageExportSizeChangeView = exportSizeChangeView
        }
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
        
        // enable edge swipe
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func _processOverlayIconSelected(_ overlay: PhotoSvg.Overlay) {
        _overlayIconImageView.image = overlay.icon.value
        _overlayIconImageView.isHidden = false
        _configureNavigaionBar()
    }
    
    private func _closeView() {
        performSegue(withIdentifier: Constants.UnwindToParentSegueID, sender: nil)
    }
    
    private func _calculateIconSizeToDraw() -> CGSize {
        guard let orgImage = photoSvgOverlayViewModel?.photo?.thumbnail.value else {
            return CGSize.zero
        }
        let orgSize = orgImage.size
        let ratio = orgSize.height / _originalPhotoImageView.frame.size.height
        let iconSize = CGSize(width: _overlayIconImageView.frame.size.width * ratio, height: _overlayIconImageView.frame.size.height * ratio)
        Log.l("ratio = \(ratio), iconSize = \(iconSize)")
        return iconSize
    }
    
    private func _disableOverlay(button: UIButton) {
        button.isUserInteractionEnabled = false
        button.isEnabled = false
        button.backgroundColor = .lightGray
    }
    
    private func _resetOverlay() {
        _selectedIcon = nil
        _overlayIconImageView.image = nil
        _overlayIconImageView.isHidden = true
        _configureNavigaionBar()
    }
    
    private func _showExportImageAlert(image: UIImage) {
        let title = NSLocalizedString("Overlaid", comment: "")
        let message = "\(NSLocalizedString("Your overlaid image size is", comment: ""))\n\(Int(image.size.width)) x \(Int(image.size.height)).\nExport to Photo library?"
        let okString = NSLocalizedString("OK", comment: "")
        let changeResolutionString = NSLocalizedString("Change size", comment: "")
        let noString = NSLocalizedString("Cancel", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okString, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.photoSvgOverlayViewModel?.saveImagePhotoLibrary(image: image)
        })
        alert.addAction(UIAlertAction(title: changeResolutionString, style: .default) { [weak self] _ in
            guard let self = self else { return }
            Log.l(l: .i)
            self._imageExportSizeChangeViewContainer.isHidden = false
            self._imageExportSizeChangeView?.configure()
        })
        alert.addAction(UIAlertAction(title: noString, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self._resetOverlay()
        })
        present(alert, animated: true)
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
    
    func showImageSaveErrorAlert(error: Error) {
        let title = NSLocalizedString("Save error", comment: "")
        let message = error.localizedDescription
        let okString = NSLocalizedString("OK", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okString, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self._closeView()
        })
        present(alert, animated: true)
    }
    
    func showImageSavedAlert() {
        let title = NSLocalizedString("Saved", comment: "")
        let message = NSLocalizedString("Your overlaid image has been saved to your photos.", comment: "")
        let okString = NSLocalizedString("OK", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okString, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self._closeView()
        })
        present(alert, animated: true)
    }
    
    func closeSizeChangeView() {
        _imageExportSizeChangeViewContainer.isHidden = true
    }
}

// MARK: - PhotoSvgOverlayNavigationFactoryReveiverProtocol

extension PhotoSvgOverlayViewController: PhotoSvgOverlayNavigationFactoryReveiverProtocol {
    func actionCloseButtonPressed(_ sender: UIButton) {
        Log.l(l: .i)
        _closeView()
    }
    
    func actionOverlayButtonPressed(_ sender: UIButton) {
        Log.l(l: .i)
        guard let selected = _selectedIcon else {
            return
        }
        let iconSize = _calculateIconSizeToDraw()
        guard iconSize != CGSize.zero else {
            return
        }
        
        // prevent multiple hit
        _disableOverlay(button: sender)
        
        // draw
        photoSvgOverlayViewModel?.overlay(icon: selected, iconSize: iconSize) { [weak self] overlaidImage in
            guard let self = self else { return }
            self._showExportImageAlert(image: overlaidImage)
        }
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
        _selectedIcon = item
        _processOverlayIconSelected(item)
    }
}
