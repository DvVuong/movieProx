//
//  GradientTabBarItem.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit

class GradientTabBarItem: UITabBarItem {

    var gradientColors: [UIColor] = [] {
        didSet {
            updateTitleGradient()
        }
    }

    private func updateTitleGradient() {
        guard let label = self.value(forKey: "view") as? UIView else {
            return
        }

        // Tạo gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        // Tạo attributed string từ tiêu đề
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12.0) // Kích thước font theo yêu cầu
        ]

        let attributedText = NSAttributedString(string: self.title ?? "", attributes: textAttributes)

        // Tạo label và áp dụng gradient layer làm mask
        let gradientLabel = UILabel()
        gradientLabel.attributedText = attributedText
        gradientLabel.sizeToFit()
        gradientLabel.layer.mask = gradientLayer

        // Thay thế label hiện tại bằng gradient label
        if let tabBarView = label.superview {
            label.removeFromSuperview()
            gradientLabel.frame = label.frame
            tabBarView.addSubview(gradientLabel)
        }
    }
}
