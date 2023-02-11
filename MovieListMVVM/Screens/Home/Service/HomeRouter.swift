//
//  HomeRouter.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import Alamofire

enum HomeRouter: Requestable {
    case getListMovie(GetListMovieRequest)
    
    var parameters: Parameters? {
        switch self {
        case .getListMovie(let request as Encodable):
            if var params = try? request.toJSON() {
                return params.merging(getBaseParams()) { (_, new) in new
                }
            }
            return getBaseParams()
        }
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
}
