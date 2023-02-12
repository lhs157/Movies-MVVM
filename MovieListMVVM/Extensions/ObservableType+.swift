//
//  ObservableType+.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import RxCocoa
import RxSwift

extension ObservableType {
    
    func asDriverComplete() -> Driver<Element> {
        return asDriver(onErrorRecover: { (error)  in
            return Driver.empty()
        })
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
