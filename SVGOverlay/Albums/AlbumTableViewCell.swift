//
//  AlbumTableViewCell.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    // MARK: - MVVM
    
    weak var albumsViewModel: AlbumsViewModelProtocol?
    var cellData: Albums.Album?
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var _thumbNailImageView: UIImageView!
    @IBOutlet private weak var _titleLabel: UILabel!
    
    // MARK: - Constants
    
    private enum Layout {
        static let cornerRadius: CGFloat = 8.0
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

extension AlbumTableViewCell {
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

extension AlbumTableViewCell {
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
    
    private func _configureTitle() {
        guard let cellData = cellData else {
            return
        }
        _titleLabel.text = cellData.title
    }
    
    private func _layoutThumbnailImage() {
        _thumbNailImageView.layer.cornerRadius = Layout.cornerRadius
        _thumbNailImageView.layer.masksToBounds = true
    }
}

// MARK: - AlbumsViewProtocol

extension AlbumTableViewCell: AlbumsViewProtocol {
    func configure() {
        _configureThumbnailImage()
        _configureTitle()
        _layoutThumbnailImage()
    }
}
