//
//  HomeViewModel.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel {
    
    private let homeService = HomeService()
    private let navigator: HomeNavigator
    private var listMovie = PublishRelay<[Movie]>()

    struct Input {
        let searchText: Driver<String>
    }
    
    struct Output {
        let movies: Observable<[Movie]>
    }
    
    init(navigator: HomeNavigator) {
        self.navigator = navigator
    }
    
    func transform(_ input: Input) -> Output {
        input.searchText
            .drive(onNext: { [weak self] (searchText) in
                guard let self = self else {return}
                self.search(searchText: searchText)
            })
            .disposed(by: disposeBag)
        return Output(movies: listMovie.asObservable())
    }
    
    func search(searchText: String) {
        // TODO: -
        let request = GetListMovieRequest(searchQuery: searchText, type: "movie")
        homeService.getMovieList(request: request, success: { [weak self] result in
            guard let self = self else { return }
            guard let movies = result.data, movies.count > 0 else {
                self.listMovie.accept([])
                return
            }
            self.listMovie.accept(movies)
        })
    }
}
