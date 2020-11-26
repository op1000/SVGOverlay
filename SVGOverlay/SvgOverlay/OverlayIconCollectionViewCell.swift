//
//  OverlayIconCollectionViewCell.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

class OverlayIconCollectionViewCell: UICollectionViewCell {
    // MARK: - MVVM
    
    weak var photoSvgOverlayViewModel: PhotoSvgOverlayViewModelProtocol?
    var cellData: PhotoSvg.Overlay?
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var _iconImageView: UIImageView!
    @IBOutlet private weak var _iconContainerView: UIView!
    
    // MARK: - life cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Log.l(l: .i)
    }
    
    deinit {
        Log.l(l: .i)
    }
}

// MARK: - UITableViewCell

extension OverlayIconCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        _iconImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _layoutCell()
    }
}

// MARK: - Private

extension OverlayIconCollectionViewCell {
    private func _configureThumbnailImage() {
        guard let cellData = cellData else {
            return
        }
        if cellData.icon.value != nil {
            _iconImageView.image = cellData.icon.value
        } else {
            cellData.icon.bind { [weak self] image in
                guard let self = self else { return }
                self._iconImageView.image = image
            }
        }
    }
    
    private func _layoutCell() {
        _iconContainerView.layer.borderWidth = 1.0
        if #available(iOS 13.0, *) {
            // NOTE: 다크/라이트모드에 따라서 border 컬러가 동적으로 변하게 하기 위한 처리
            _iconContainerView.layer.borderColor = UIColor.label.cgColor
        } else {
            if traitCollection.userInterfaceStyle == .dark {
                _iconContainerView.layer.borderColor = UIColor.white.cgColor
            } else {
                _iconContainerView.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
}

// MARK: - AlbumsViewProtocol

extension OverlayIconCollectionViewCell: PhotoSvgOverlayViewProtocol {
    func configure() {
        _configureThumbnailImage()
        _layoutCell()
    }
}
