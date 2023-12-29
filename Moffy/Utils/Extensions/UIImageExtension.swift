//
//  UIImageExtension.swift
//  Moffy
//
//  Created by macbook on 14/12/2023.
//

import UIKit
import SDWebImage

extension UIImage {
    class func image(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func gradientImage(bounds: CGRect,
                             colors: [UIColor],
                             startPoint: CGPoint,
                             endPoint: CGPoint,
                             type: CAGradientLayerType = .axial,
                             locations: [NSNumber]? = nil
    ) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.type = type
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if let locations = locations {
            gradientLayer.locations = locations
        }
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { ctx in
          gradientLayer.render(in: ctx.cgContext)
        }
    }
}
