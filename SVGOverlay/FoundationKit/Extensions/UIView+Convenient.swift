//
//  UIView+Convenient.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/26.
//

import UIKit

extension UIView {
    func takeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: self.frame.size.width, height: self.frame.size.height - 5))
        let rect = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
