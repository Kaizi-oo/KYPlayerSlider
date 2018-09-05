//
//  UIImage+Color.swift
//  xqapp_Demo
//
//  Created by kyang on 2018/9/4.
//  Copyright © 2018年 chinaxueqian. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    convenience init(color: UIColor, rect: CGRect) {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: cgImage)
    }

    convenience init(color: UIColor) {
        self.init(color: color, rect: CGRect(x: 0, y: 0, width: 1, height: 1))
    }

    func imageReplaced(with color: UIColor) -> UIImage? {
        let rect = CGRect(origin: .zero, size: self.size)
        guard let cgImage = self.cgImage else { return nil }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        context?.clip(to: rect, mask: cgImage)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }

    func addMask(with tintColor: UIColor) -> UIImage? {
        let rect = CGRect(origin: .zero, size: self.size)
        guard let cgImage = self.cgImage else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        //原image
        context?.setBlendMode(CGBlendMode.normal)
        context?.draw(cgImage, in: rect)
        //mask color
        context?.clip(to: rect, mask: cgImage)
        context?.setFillColor(tintColor.cgColor)
        context?.fill(rect)

        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }
}
