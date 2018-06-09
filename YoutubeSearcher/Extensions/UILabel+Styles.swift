//
//  UILabel+Styles.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/7/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setDefaultFont(of size: CGFloat = 12) {
        self.font = UIFont.defaultFont(of: size)
    }
    
    func setRegularFont(of size: CGFloat = 12) {
        self.font = UIFont.regularFont(of: size)
    }
    
    func makeHeaderLabel() {
        self.textColor = UIColor.gray
        self.setDefaultFont(of: 15)
    }
}
