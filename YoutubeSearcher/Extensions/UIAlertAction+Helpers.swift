//
//  UIAlertAction+Helpers.swift
//  YoutubeSearcher
//
//  Created by Leonard Lopez on 6/9/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    static func ok() -> UIAlertAction {
        return UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        )
    }
    
    static func cancel() -> UIAlertAction {
        return UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
    }
}
