//
//  Storyboard+.swift
//  MovieListMVVM
//
//  Created by mac on 12/02/2023.
//

import UIKit

public enum StoryboardName: String {
    case main = "Main"
}

public protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {
    public static func instantiate(from storyboardName: StoryboardName) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
