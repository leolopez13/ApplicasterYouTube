//
//  UIView+FrameManagement.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/7/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit

extension UIView {
    var width: CGFloat {
        return self.frame.size.width
    }
    
    var height: CGFloat {
        return self.frame.size.height
    }
    
    var top: CGFloat {
        return self.frame.origin.y
    }

    var bottom: CGFloat {
        return top + height
    }

    var left: CGFloat {
        return self.frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    func makeRounded(with radius: CGFloat = 5.0) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func addDropShadow() {
        layer.shadowColor = UIColor.almostBlack().cgColor
        layer.shadowOffset = CGSize.init(width: 0, height: 1)
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        clipsToBounds = false
    }
}
