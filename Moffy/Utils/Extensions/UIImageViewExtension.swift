//
//  UIImageViewExtension.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImage(with path: String) {
        guard let url = URL(string: URLs.domainImage + path) else {
            return
        }
        self.sd_setImage(with: url , placeholderImage: UIImage(named: "mingcute_movie-line"))
    }
    
    func setConerRadius(_ numberRadius: CGFloat = 18) {
        self.layer.cornerRadius = numberRadius
        self.layer.masksToBounds = true
    }
}
