//
//  GenerTvShowObject.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import UIKit
import RealmSwift

class GenerTvShowObject: BaseObject {
    @Persisted var isSelected: Bool
    var garedient: CAGradientLayer?
    
    convenience init(genre: GenerTvShow) {
        self.init()
        self.id = "\(genre.id)"
        self.name = genre.name
    }
}
