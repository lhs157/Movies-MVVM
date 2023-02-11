//
//  HomeViewController.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private lazy var viewModel = HomeViewModel(navigator: .init(self.navigationController))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
