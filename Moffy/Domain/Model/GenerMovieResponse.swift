//
//  GenerResponse.swift
//  Moffy
//
//  Created by macbook on 15/12/2023.
//

import UIKit

class GenerMovieResponse: Codable {
    var genres: [GenresMovie]
}

class GenresMovie: Codable {
    var id: Int
    var name: String
}
