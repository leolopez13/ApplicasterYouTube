//
//  NSDate+Formatting.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/8/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import Foundation

extension Date {
    
    // 06/08/18
    func dateToStringShort() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .short
        return dateFormat.string(from: self)
    }
    
}
