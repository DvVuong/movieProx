//
//  GenerTvShowResponse.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import Foundation

struct GenerTvShowResponse: Codable{
    var genres: [GenerTvShow]
}

struct GenerTvShow: Codable {
    var id: Int
    var name: String
}
