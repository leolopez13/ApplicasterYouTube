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
        // want to get rid of the PT so we can scan through the string and pick apart the hours, minutes, and seconds
        let durationString = self.replacingOccurrences(of: "PT", with: "")
        
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        var timeString = ""
        for character in durationString {
            // build up timeString with numbers
            if Int("\(character)") != nil {
                timeString += "\(character)"
            }
            // found a character, has to be H, M, or S. set corresponding value based on the character
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
                // set timeString back to 0 since we picked out the value and so we can do it for the next time interval
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
