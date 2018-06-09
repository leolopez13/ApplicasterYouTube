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
        let ok = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
