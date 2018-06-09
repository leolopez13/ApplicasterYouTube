//
//  YouTubeVideo.swift
//  YoutubeSearcher
//
//  Created by Leonard Lopez on 6/9/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

struct YouTubeVideo {
    
    enum YouTubeVideoError: Error {
        case invalidParameters
    }
    
    var id: String
    var thumbnailURL: URL
    var title: String
    var playlistTitle: String
    var duration: String
    var publishDate: String
    
    init(id: String, thumbnailURL: URL, title: String, playlistTitle: String, duration: String, publishDate: String) {
        self.id = id
        self.thumbnailURL = thumbnailURL
        self.title = title
        self.playlistTitle = playlistTitle
        self.duration = duration
        self.publishDate = publishDate
    }
    
    static func buildWithYouTubeVideoResponse(youtubeVideo: GTLRYouTube_Video) throws -> YouTubeVideo {
        
        guard let id = youtubeVideo.identifier,
            let thumbnailURLString = youtubeVideo.snippet?.thumbnails?.defaultProperty?.url,
            let thumbnailURL = URL(string: thumbnailURLString),
            let title = youtubeVideo.snippet?.title,
            let playlistTitle = youtubeVideo.snippet?.channelTitle,
            let durationISOString = youtubeVideo.contentDetails?.duration,
            let publishDateDate = youtubeVideo.snippet?.publishedAt?.date else {
                throw YouTubeVideoError.invalidParameters
        }
        
        let duration = durationISOString.formatISO8601Duration()
        let publishDate = publishDateDate.dateToStringShort()
        
        return YouTubeVideo(id: id, thumbnailURL: thumbnailURL, title: title, playlistTitle: playlistTitle, duration: duration, publishDate: publishDate)
    }
    
}
