//
//  GetListMovieRequest.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import Foundation

struct GetListMovieRequest: Codable {
    var searchQuery: String?
    var type: String?
    
    enum CodingKeys: String, CodingKey {
        case searchQuery = "s"
        case type
    }
}
