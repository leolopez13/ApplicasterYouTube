//
//  UIViewController+Helpers.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/8/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction.ok())
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title : String, message: String, defaultButtonTitle: String, cancelAction: UIAlertAction, completionHandler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let defaultButton = UIAlertAction(
            title: defaultButtonTitle,
            style: .default,
            handler: nil
        )
        alert.addAction(defaultButton)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}
