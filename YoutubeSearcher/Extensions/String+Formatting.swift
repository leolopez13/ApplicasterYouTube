//
//  NSString+Formatting.swift
//  YoutubeSearcher
//
//  Created by Leonard Lopez on 6/9/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import Foundation

extension String {
    
    func formatISO8601Duration() -> String {
        //ISO 8601 duration
        //ex: PT3H35M30S
        let durationString = self.replacingOccurrences(of: "PT", with: "")
        
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        var timeString = ""
        for character in durationString {
            if Int("\(character)") != nil {
                timeString += "\(character)"
            }
            else {
                if character == "H" {
                    if let hoursInt = Int(timeString) {
                        hours = hoursInt
                    }
                }
                else if character == "M" {
                    if let minutesInt = Int(timeString) {
                        minutes = minutesInt
                    }
                }
                else if character == "S" {
                    if let secondsInt = Int(timeString) {
                        seconds = secondsInt
                    }
                }
                timeString = ""
            }
        }
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }

    
}
