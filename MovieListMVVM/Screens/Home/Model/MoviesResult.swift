//
//  MoviesResult.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import Foundation
// MARK: - CommonData
struct MoviesResult: Codable {
    var data: [Movie]?
    var totalResults, response, error: String?

    enum CodingKeys: String, CodingKey {
        case data = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}

// MARK: - Search
struct Movie: Codable {
    var title, year, imdbID: String?
    var type: TypeEnum?
    var poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
}
