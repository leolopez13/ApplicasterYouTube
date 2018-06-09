//
//  DataManager.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/7/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import Foundation
import Reachability

class DataManager: NSObject {
    
    let reach = Reachability.forInternetConnection()
    
    func hasConnection() -> Bool {
        return reach?.isReachable() ?? false
    }
    
}
