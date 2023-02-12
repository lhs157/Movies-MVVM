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
    enum LoadingType {
        case none
        case getNew
        case loadMore
    }
    
    private let homeService = HomeService()
    private let navigator: HomeNavigator
    
    // Search Text
    
    struct Input {
        let searchText: Driver<String>
        let doLoadMore: Driver<Bool>
    }
    struct Output {
        let listMovie: Observable<[Movie]>
    }
    
    private var listMovie = BehaviorRelay<[Movie]>(value: [])
    
    // Loading state
    var loadingType = BehaviorRelay<LoadingType>(value: .none)
    var isLoading: Bool { return loadingType.value != .none }
    
    private var currentSearchText = ""
    
    // Load more
    private var currentPage = 1 // page Start from 1
    private var totalResult = 1
    
    var hasMorePages: Bool {
        return listMovie.value.count < totalResult
    }
    
    var nextPage: Int {
        guard hasMorePages else {
            return currentPage
        }
        currentPage += 1
        return currentPage
    }
    
    init(navigator: HomeNavigator) {
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        input.searchText
            .drive(onNext: { [weak self] (searchText) in
                guard let self = self else {return}
                self.currentSearchText = searchText
                self.resetPages()
                self.loadMovies(searchText: searchText, loadingType: .getNew)
            }).disposed(by: disposeBag)
        
        input.doLoadMore.drive(onNext: { [weak self] (shouldLoadMore) in
            guard let self = self, shouldLoadMore else {return}
            self.loadMovies(searchText: self.currentSearchText, loadingType: .loadMore)
        }).disposed(by: disposeBag)
        return Output(listMovie: listMovie.asObservable())
    }
    
    func loadMovies(searchText: String, loadingType: LoadingType) {
        if loadingType == .loadMore, !hasMorePages {
            return
        }
        
        let request = GetListMovieRequest(searchQuery: searchText, type: "movie", page: loadingType == .getNew ? 1 : nextPage)
        homeService.getMovieList(request: request, success: { [weak self] result in
            guard let self = self else { return }
            self.setListMovieValue(result, loadingType: loadingType)
        })
    }
    
    private func resetPages() {
        currentPage = 1
        totalResult = 1
    }
            
    private func setListMovieValue(_ movieResult: MoviesResult, loadingType: LoadingType) {
        guard let movies = movieResult.data, movies.count > 0 else {
            return
        }
        if let totalResult = Int(movieResult.totalResults ?? "") {
            self.totalResult = totalResult
        }
        
        self.listMovie.accept(loadingType == .getNew ? movies : listMovie.value + movies)
    }
}
