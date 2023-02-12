//
//  MovieItemCellViewModel.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import RxCocoa
import RxSwift


final class MovieItemCellViewModel {
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let name: Driver<String>
        let thumbnail: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let name: Driver<String> = input.trigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self, let name = self.movie.title else {return Driver.empty()}
                return Driver.just(name)
            }
        let thumbnail: Driver<String> = input.trigger
            .flatMapLatest { [weak self] (_) in
                guard let self = self else {return Driver.empty()}
                guard let thumnail = self.movie.poster else {return Driver.empty()}
                return Driver.just(thumnail)
            }
        
        return Output(name: name, thumbnail: thumbnail)
    }
}
