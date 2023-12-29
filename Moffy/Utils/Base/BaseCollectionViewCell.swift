//
//  BaseCollectionViewCell.swift
//  Moffy
//
//  Created by macbook on 14/12/2023.
//

import UIKit
import Combine

class BaseCollectionViewCell: UICollectionViewCell, ViewProtocol {
    var subscriptions = [AnyCancellable]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
        setProperties()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addComponents()
        setConstraints()
        setProperties()
        binding()
    }
    
    func addComponents() {}
    
    func setConstraints() {}
    
    func setProperties() {}
    
    func setColor() {}
    
    func binding() {}
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setColor()
    }
}
