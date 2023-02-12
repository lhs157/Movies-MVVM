//
//  HomeViewController.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    private let disposeBag = DisposeBag()

    @IBOutlet weak var searchTextField: UITextField!
    private var searchText = BehaviorRelay<String>(value: "Dragon Ball")
    private var triggerLoadMore = BehaviorRelay<Bool>(value: false)
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var viewModel = HomeViewModel(navigator: .init(self.navigationController))
    override func viewDidLoad() {
        super.viewDidLoad()
        configGUI()
        bindView()
        bindViewModel()
    }
    
    private func bindView() {
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] (event) in
                guard let self = self, let text = self.searchTextField.text else {return}
                
                self.showLoading()
                self.searchText.accept(text)
            }
            .disposed(by: disposeBag)

    }
    
    private func bindViewModel() {
        let input = HomeViewModel.Input(searchText: searchText.asDriverComplete(), doLoadMore: triggerLoadMore.asDriverComplete())
        let output = viewModel.transform(input: input)
        output.listMovie.bind(to: collectionView.rx.items(cellIdentifier: "MovieItemCell", cellType: MovieItemCell.self)) { (row, movie, cell) in
            cell.configure(viewModel: .init(movie: movie))
        }.disposed(by: disposeBag)
    }
    
    private func configGUI() {
        collectionView.register(UINib(nibName: "MovieItemCell", bundle: nil), forCellWithReuseIdentifier: "MovieItemCell")
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(2))
            let expectItemSize: CGFloat = (UIScreen.main.bounds.width - 48 - totalSpace)/2
            flowLayout.itemSize = CGSize(width: expectItemSize, height: expectItemSize * 4/3)
        }
    }
        
    @IBAction func searchTapped(_ sender: Any) {
        view.endEditing(true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}
