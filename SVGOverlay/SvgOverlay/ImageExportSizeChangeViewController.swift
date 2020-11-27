//
//  ImageExportSizeChangeViewController.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/27.
//

import UIKit
import SnapKit

class ImageExportSizeChangeViewController: UIViewController {
    // MARK: - MVVM
    
    var photoSvgOverlayViewModel: PhotoSvgOverlayViewModelProtocol?
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var _sizeLabel: UILabel!
    @IBOutlet private weak var _exportButton: UIButton!
    @IBOutlet private weak var _sizeSlider: UISlider!
    
    // MARK: - Properties - private
    
    private var _changedSize: CGSize?
    private var _originalSize: CGSize?
    
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

extension ImageExportSizeChangeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Private

extension ImageExportSizeChangeViewController {
    private func _initializeSettings() {
        _sizeSlider.minimumValue = 10
        _sizeSlider.maximumValue = 100
        _sizeSlider.value = 100
        
        if let image = photoSvgOverlayViewModel?.overlaidImage {
            _originalSize = image.size
            // "890.762363821678" 같은 형태로 표시되는 것을 방지히기 위해서 소수점 절사
            _sizeLabel.text = "\(Int(image.size.width)) x \(Int(image.size.height))"
        }
    }
    
    private func _initializeUi() {
        _createExportButtonAppearance()
    }
    
    private func _createExportButtonAppearance() {
        guard let button = _exportButton else {
            return
        }
        let titleString = NSLocalizedString("Export", comment: "")
        button.setTitle(titleString, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: NavigationFactory.Layout.textButtonLabelFontSize)
        button.snp.makeConstraints(_makeOverlayButtonLayout)
        button.layer.cornerRadius = NavigationFactory.Layout.textButtonHeight / 2.0
        button.layer.masksToBounds = true
        
        if traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
        } else {
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
        }
        button.setTitleColor(.gray, for: .disabled)
    }
    
    private func _makeOverlayButtonLayout(_ make: ConstraintMaker) {
        let titleString = NSLocalizedString("Export", comment: "")
        let size: CGSize = titleString.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: NavigationFactory.Layout.titleLabelFontSize)])
        make.width.equalTo(size.width + NavigationFactory.Layout.titleLabelBothSidesMargin)
        make.height.equalTo(NavigationFactory.Layout.textButtonHeight)
    }
}

// MARK: - Actions

extension ImageExportSizeChangeViewController {
    @IBAction func exportButtonPressed(_ sender: Any) {
        Log.l(l: .i)
        guard let size = _changedSize else {
            return
        }
        // "890.762363821678" 같은 형태로 표시되는 것을 방지히기 위해서 소수점 절사
        let width = Int(size.width)
        let height = Int(size.height)
        let newsize = CGSize(width: CGFloat(width), height: CGFloat(height))
        photoSvgOverlayViewModel?.resizeOverlaidImage(size: newsize) { [weak self] image in
            guard let self = self else { return }
            self.photoSvgOverlayViewModel?.closeSizeChangeView()
            self.photoSvgOverlayViewModel?.saveImagePhotoLibrary(image: image)
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        Log.l(l: .i)
        Log.l("_sizeSlider.value = \(_sizeSlider.value)")
        guard let size = _originalSize else {
            return
        }
        let ratio = CGFloat(_sizeSlider.value / 100.0)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        _changedSize = newSize
        // "890.762363821678" 같은 형태로 표시되는 것을 방지히기 위해서 소수점 절사
        _sizeLabel.text = "\(Int(newSize.width)) x \(Int(newSize.height))"
    }
}

// MARK: - PhotoSvgOverlayViewProtocol

extension ImageExportSizeChangeViewController: PhotoSvgOverlayViewProtocol {
    func configure() {
        _initializeSettings()
        _initializeUi()
    }
}
