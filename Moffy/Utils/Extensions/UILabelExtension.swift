//
//  UILabelExtension.swift
//  Moffy
//
//  Created by macbook on 15/12/2023.
//

import UIKit
extension UILabel {
    func cornerRadius(with number: CGFloat? = 15) {
        guard let number = number else {
            return
        }
        self.layer.cornerRadius = number
        self.layer.masksToBounds = true
    }
}
