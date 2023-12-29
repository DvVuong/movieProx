//
//  MovieResponse.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import Foundation

struct MovieRespone: Codable {
    var page: Int?
    var results: [Movie]?
    var totalPages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalPages = "total_pages"
    }
}

struct Movie: Codable {
    var backdropPath: String?
    var id: Int?
    var title: String?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var posterPath: String?
    var mediaType: String?
    var releaseDate: String?
    var voteAverage: Float?
    var isFavorites: Bool?
    var name: String?
    var firstAirDate: String?
    var genreIds: [Int]

        private enum CodingKeys: String, CodingKey {
            case backdropPath = "backdrop_path"
            case id
            case title
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview
            case posterPath = "poster_path"
            case mediaType = "media_type"
            case releaseDate = "release_date"
            case voteAverage = "vote_average"
            case isFavorites
            case name
            case firstAirDate = "first_air_date"
            case genreIds = "genre_ids"
        }
}

