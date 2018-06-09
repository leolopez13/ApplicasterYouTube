//
//  UIFont+YoutubeSearcher.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/7/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit

extension UIFont {
    
    fileprivate static let ProximaSemiBold = "ProximaNova-Semibold"
    fileprivate static let ProximaRegular = "ProximaNova-Regular"
    
    static func defaultFont(of size: CGFloat) -> UIFont? {
        guard let font = UIFont.init(name: UIFont.ProximaSemiBold, size: size) else { return nil }
        return font
    }
    
    static func regularFont(of size: CGFloat) -> UIFont? {
        guard let font = UIFont.init(name: UIFont.ProximaRegular, size: size) else { return nil }
        return font
    }
}
