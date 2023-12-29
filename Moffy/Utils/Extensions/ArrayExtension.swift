//
//  ArrayExtension.swift
//  Moffy
//
//  Created by MRX on 28/12/2023.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
