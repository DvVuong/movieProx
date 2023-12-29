//
//  Global.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import UIKit
import Combine

class Global {
    static let shared = Global()
    
    func fecth() {
        MovieManager.shared.fetchGenerMovie()
        TvShowManager.shared.fetchGenerTV()
        
    }
}
