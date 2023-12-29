//
//  CAGradientLayerExtension.swift
//  Moffy
//
//  Created by macbook on 14/12/2023.
//

import UIKit
import QuartzCore

extension CAGradientLayer {
    class func create(colors: [UIColor],
                      locations: [NSNumber],
                      affineTransform: CGAffineTransform,
                      bounds: CGRect
    ) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.transform = CATransform3DMakeAffineTransform(affineTransform)
        gradient.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        gradient.position = CGPoint(x: bounds.midX, y: bounds.midY)
        return gradient
    }
    
    func convertGradientLayerToColors(gradientLayer: CAGradientLayer) -> [UIColor] {
        guard let cgColors = gradientLayer.colors as? [CGColor] else {
            return []
        }
        
        let uiColors = cgColors.map { UIColor(cgColor: $0) }
        
        return uiColors
    }
}
