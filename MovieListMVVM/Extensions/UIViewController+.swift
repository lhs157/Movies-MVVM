//
//  UIViewController+.swift
//  MovieListMVVM
//
//  Created by mac on 11/02/2023.
//

import UIKit
import SVProgressHUD


extension UIViewController {
    func presentInFullScreen(_ destinationVC: UIViewController, animated: Bool = true) {
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: animated, completion: nil)
    }
    
    func topController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController {
        if let navigationController = controller as? UINavigationController {
            return topController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topController(controller: presented)
        }
        return controller ?? UIViewController()
    }
}

// Show/Hide Loading
extension UIViewController {
    func showLoading(message: String = "", isShowMask: Bool = false) {
        if isShowMask {
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        if !message.isEmpty {
            SVProgressHUD.show(withStatus: message)
        } else {
            SVProgressHUD.show()
        }
    }
    
    @objc func dismissLoading() {
        SVProgressHUD.dismiss()
    }
}

