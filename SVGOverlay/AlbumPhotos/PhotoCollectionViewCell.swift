//
//  PhotoCollectionViewCell.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    // MARK: - MVVM
    
    weak var albumPhotosViewModel: AlbumPhotosViewModelProtocol?
    var cellData: Album.Photo?
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var _thumbNailImageView: UIImageView!
    
    // MARK: - Constants
    
    private enum Layout {
        static let cornerRadius: CGFloat = 16.0
    }

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

extension PhotoCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        _thumbNailImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _layoutThumbnailImage()
    }
}

// MARK: - Private

extension PhotoCollectionViewCell {
    private func _configureThumbnailImage() {
        guard let cellData = cellData else {
            return
        }
        if cellData.thumbnail.value != nil {
            _thumbNailImageView.image = cellData.thumbnail.value
        } else {
            cellData.thumbnail.bind { [weak self] image in
                guard let self = self else { return }
                self._thumbNailImageView.image = image
            }
        }
    }
    
    private func _layoutThumbnailImage() {
        _thumbNailImageView.layer.cornerRadius = Layout.cornerRadius
        _thumbNailImageView.layer.masksToBounds = true
    }
}

// MARK: - AlbumsViewProtocol

extension PhotoCollectionViewCell: AlbumPhotosViewProtocol {
    func configure() {
        _configureThumbnailImage()
        _layoutThumbnailImage()
    }
}
