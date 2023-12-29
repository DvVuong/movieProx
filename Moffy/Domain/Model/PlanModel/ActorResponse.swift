//
//  ActorResponse.swift
//  Moffy
//
//  Created by MRX on 26/12/2023.
//

import Foundation

struct ActorResponse: Codable {
    var page: Int?
    var results: [Actor]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case results
    }
}

struct Actor: Codable {
    var adult: Bool?
    var gender: Int?
    var id: Int?
    var knownForDepartment: String?
    var knownFor: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case knownFor = "known_for"
    }
}
