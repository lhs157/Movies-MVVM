//
//  AlertView.swift
//  MovieListMVVM
//
//  Created by mac on 11/02/2023.
//

import UIKit

class AlertView {
    
    static let shared = AlertView()
    var isShowingPopupInternet = false
    private var topViewController: UIViewController {
        return UIViewController().topController()
    }
    
    private var alertController: UIAlertController!
    func presentSimpleAlert(title: String, message: String, buttonTitle: String = "OK", completeHandler: (() -> Void)? = nil) {
        dismisAlertView { [weak self] in
            guard let self = self else { return }
            self.alertController = self.alertView(title: title, message: message, buttonTitle: buttonTitle, completeHandler: completeHandler)
            self.topViewController.present(self.alertController, animated: true)
        }
    }
    
    func presentConfirmAlert(title: String, message: String, okButtonTitle: String = "OK", cancelButtonTitle: String = "Cancel", okHanlder: (() -> Void)? = nil) {
        dismisAlertView { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { _ in
                okHanlder?()
            }))
            alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: nil))
            self.alertController = alert
            self.topViewController.present(self.alertController, animated: true)
        }
    }
    
    func dismissInternetWarning() {
        if isShowingPopupInternet {
            self.dismisAlertView()
            isShowingPopupInternet = false
        }
    }
    
    func dismisAlertView(completeHandler: (() -> Void)? = nil) {
        if alertController != nil {
            alertController.dismiss(animated: false) {
                completeHandler?()
            }
            return
        }
        completeHandler?()
    }
    
    private func alertView(title: String, message: String, buttonTitle: String, completeHandler: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            completeHandler?()
        }))
        return alert
    }
}
