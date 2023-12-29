//
//  GenerObject.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import UIKit
import RealmSwift

class GenerMovieObject: BaseObject {
    @Persisted var isSelected: Bool
    var image: UIImage?
    
    convenience init(genre: GenresMovie) {
        self.init()
        self.id = "\(genre.id)"
        self.name = genre.name
    }
}
