//
//  HomeService.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import Alamofire

struct HomeService {
    func getMovieList(request: GetListMovieRequest, success: @escaping (MoviesResult) -> Void) {
        // TODO: -
        APIRequest.request(HomeRouter.getListMovie(request), success: success)
    }
}
