//
//  UIColor+YoutubeSearcher.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/8/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        let myHex = hex.replacingOccurrences(of: "#", with: "0x")
        
        var hexInt: uint = 0
        
        if Scanner.init(string: myHex).scanHexInt32(&hexInt) {
            return UIColor.init(red: (CGFloat)((hexInt & 0xFF0000) >> 16) / 255.0,
                                green: (CGFloat)((hexInt & 0x00FF00) >> 8) / 255.0,
                                blue: (CGFloat)((hexInt & 0x0000FF)) / 255.0,
                                alpha: alpha)
        }
        else {
            return UIColor.black
        }
    }
    
    static func soapStoneGrey() -> UIColor {
        return UIColor.colorWithHex(hex: "E6E7E8")
    }
    
    static func youtubeRed() -> UIColor {
        return UIColor.colorWithHex(hex: "FB0008")
    }
}
