//
//  NSObjectExtension.swift
//  Moffy
//
//  Created by macbook on 14/12/2023.
//

import Foundation

extension NSObject {
    public class var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return String(describing: self)
    }
}
