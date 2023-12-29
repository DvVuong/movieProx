//
//  UITextViewExtension.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit

extension UITextView {
    func setBoderRadius(_ number: CGFloat = 1) {
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
        self.layer.borderWidth = number
        self.layer.borderColor = UIColor(rgb: 0xFFFFFF, alpha: 0.3).cgColor
    }
}
