//
//  AppDelegate.swift
//  BookWorm
//
//  Created by 정준영 on 2023/07/31.
//

import UIKit.UIViewController

extension UIViewController {
    func showCancelAlert(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        cancelTitle: String? = "확인"
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
