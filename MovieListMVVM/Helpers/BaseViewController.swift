//
//  BaseViewController.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController, Storyboarded {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
