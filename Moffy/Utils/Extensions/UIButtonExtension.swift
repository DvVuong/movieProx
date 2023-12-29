//
//  UIButtonExtension.swift
//  Moffy
//
//  Created by macbook on 15/12/2023.
//

import UIKit
extension UIButton {
    func cornerradius(with number: CGFloat? = 24.0) {
        guard let number = number else {
            return
        }
        self.layer.cornerRadius = number
        self.layer.masksToBounds = true
    }
    
    func createGradientLayer(with startColor: UIColor? = UIColor(rgb: 0x7E4CE3), endColor: UIColor? = UIColor(rgb: 0x2385EC)){
        let gradientLayer = CAGradientLayer()
        guard let startColor = startColor, let endColor = endColor else {
            return
        }
        
        let color1 = startColor.cgColor
        let color2 = endColor.cgColor
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [color1, color2]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        self.layer.addSublayer(gradientLayer)
    }
    
     func applyGradientForText(to text: String) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [UIColor(rgb: 0xEB279D).cgColor, UIColor(rgb: 0xF14E4E).cgColor]

            UIGraphicsBeginImageContext(gradientLayer.bounds.size)
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.setTitleColor(UIColor(patternImage: gradientImage!), for: .normal)
            self.setTitle(text, for: .normal)
        }
}
