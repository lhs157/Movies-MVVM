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
        case newText
        case nextPage
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
    
    // Load more
    private var currentPage = 0 // page Start from 1
    private var totalPageCount = 1
    
    var hasMorePages: Bool {
        return currentPage < totalPageCount
    }
    
    var nextPage: Int {
        guard hasMorePages else { return currentPage }
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
                self.loadMovies(searchText: searchText, loadingType: .newText)
            })
            .disposed(by: disposeBag)
        return Output(listMovie: listMovie.asObservable())
    }
    
    func loadMovies(searchText: String, loadingType: LoadingType) {
        let request = GetListMovieRequest(searchQuery: searchText, type: "movie", page: nextPage)
        homeService.getMovieList(request: request, success: { [weak self] result in
            guard let self = self else { return }
            self.setListMovieValue(result)
        })
    }
    
    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        listMovie.accept([])
    }
    
    // Search new
    func updateQuery(searchText: String) {
        resetPages()
        loadMovies(searchText: searchText, loadingType: .newText)
    }
    
    // Load next page
    func loadNextPage() {
        guard hasMorePages, !isLoading else {
            return
        }
        //        loadMovies(searchText: searchText.value, loadingType: .nextPage)
    }
    
    private func setListMovieValue(_ movieResult: MoviesResult) {
        guard let movies = movieResult.data, movies.count > 0 else {
            return
        }
        if let totalPage = Int(movieResult.totalResults ?? "") {
            self.totalPageCount = totalPage
        }
        
        self.listMovie.accept(listMovie.value + movies)
    }
}
