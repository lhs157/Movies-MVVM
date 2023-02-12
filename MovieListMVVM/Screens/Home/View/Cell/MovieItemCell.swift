//
//  MovieItemCell.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class MovieItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    private var viewModel: MovieItemCellViewModel!
    private var disposeBag = DisposeBag()

    
    override class func awakeFromNib() {
        
    }
    
    func configure(viewModel: MovieItemCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
    }
    
    private func bindViewModel() {
        let layoutSubviews = rx.sentMessage(#selector(UICollectionViewCell.layoutSubviews)).take(1).mapToVoid().asDriverComplete()
        let input = MovieItemCellViewModel.Input(trigger: layoutSubviews)
        
        let output = viewModel.transform(input: input)
        output.thumbnail
            .drive(onNext: { [weak self] (url) in
                guard let self = self else {return}
                if let postterURL = URL(string: url) {
                    self.imageView.kf.setImage(with: postterURL)
                }
            })
            .disposed(by: disposeBag)
        output.name
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
