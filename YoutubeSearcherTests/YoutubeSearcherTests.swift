//
//  YoutubeSearcherTests.swift
//  YoutubeSearcherTests
//
//  Created by Lopez, Leonard on 6/7/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import XCTest
import GoogleAPIClientForREST

@testable import YoutubeSearcher

class YoutubeSearcherTests: XCTestCase {
    
    var video: YouTubeVideo!
    
    override func setUp() {
        super.setUp()
        video = YouTubeVideo(id: "1", thumbnailURL: URL(string: "www.youtube.com")!, title: "videoTitle", playlistTitle: "playlistTitle", duration: "3:05", publishDate: "6/7/18")
    }
    
    override func tearDown() {
        super.tearDown()
        video = nil
    }
    
    // dummy test to make sure we have a video
    func testMakeSureVideoNotNil() {
        XCTAssertNotNil(video)
    }
    
    // Test to make sur we get the invalidParameters error when a malformed google youtube object gets sent in to build the video
    func testBadYouTubeVideoData() {
        let youtubeVideo = GTLRYouTube_Video.init(json: nil)
        do {
            let _ = try YouTubeVideo.buildWithYouTubeVideoResponse(youtubeVideo: youtubeVideo)
        }
        catch let error {
            XCTAssertTrue(error.localizedDescription == YouTubeVideo.YouTubeVideoError.invalidParameters.localizedDescription, "Got correct error - Got the invalid parameter error when passing in a youtube video that had bad parameters")
        }
    }
    
    // get an actual youtube video and make sure we get our object back with no errors
    func testBuildWithYouTubeVideo() {
        let youtubeVideo = GTLRYouTube_Video.init(json: getYouTubeRawVideo())
        do {
            let myNewVideo = try YouTubeVideo.buildWithYouTubeVideoResponse(youtubeVideo: youtubeVideo)
            XCTAssertNotNil(myNewVideo)
        }
        catch let error {
            XCTAssertNil(error, "If we got an error, there was a problem with the youtube data. Should not happen in this case")
        }
    }
    
    func testISOFormattingWithHours() {
        let durationISOString = "PT1H13M29S"
        XCTAssertTrue(durationISOString.formatISO8601Duration() == "1:13:29", "ISO duration string was formatted as expected with hours")
    }
    
    func testISOFormattingWithMinutes() {
        let durationISOString = "PT13M29S"
        XCTAssertTrue(durationISOString.formatISO8601Duration() == "13:29", "ISO duration string was formatted as expected with minutes")
    }
    
    func testISOFormattingWithSeconds() {
        let durationISOString = "PT29S"
        XCTAssertTrue(durationISOString.formatISO8601Duration() == "0:29", "ISO duration string was formatted as expected with seconds")
    }
    
    func getYouTubeRawVideo() -> [String: Any] {
        return [
            "contentDetails" : [
                "caption" : false,
                "definition" : "hd",
                "dimension" : "2d",
                "duration" : "PT13M29S",
                "licensedContent" : 0,
                "projection" : "rectangular"
            ],
            "etag" : "DuHzAJ-eQIiCIp7p4ldoVcVAOeY/mxPhy8-1ogJ-hcmPm2fZqskHh_I",
            "id" : "g55ZqyCSUHg",
            "kind" : "youtube#video",
            "snippet" : [
                "categoryId" : 24,
                "channelId" : "UC3e_ZCYzV5LHcjks2pNuprQ",
                "channelTitle" : "Life Funny",
                "defaultAudioLanguage" : "es",
                "description" : "IF YOU LAUGH YOU LOSE Compilation Funny cats and dogs Cute funny Pets 2018 #33\nIF YOU LAUGH LOSE  Compilation Funny cats and dogs  Cute funny Pets 2018\n* Everyday we publish the videos that focused on delivering the best funny videos; entertaining fails videos, try not to laugh, amazing funny kids fails & cute babies and much more. We hope that these funny vines videos will make your day. Not to mention, the adorable yet super funny animal vines videos will warm your heart.\nhttps://youtu.be/B9fNTy0aXAU\n* If you have an issue with me posting this song or video please contact me through email or the YouTube private messaging system. Once I have received your message and determined you are the proper owner of this content I will have it removed!\n* Want to submit your videos? Send us your video links via email and we'll put them in our compilations! \nEMAIL: trthanh182@gmail.com\n* Don't forget like, comment and share the best cute funny videos for your family and friends. Thanks you !!\n Suscribete for more videos: https://goo.gl/s8m8LJ",
                "liveBroadcastContent" : "none",
                "localized" : [
                    "description" : "IF YOU LAUGH YOU LOSE Compilation Funny cats and dogs Cute funny Pets 2018 #33\nIF YOU LAUGH LOSE  Compilation Funny cats and dogs  Cute funny Pets 2018\n* Everyday we publish the videos that focused on delivering the best funny videos; entertaining fails videos, try not to laugh, amazing funny kids fails & cute babies and much more. We hope that these funny vines videos will make your day. Not to mention, the adorable yet super funny animal vines videos will warm your heart.\nhttps://youtu.be/B9fNTy0aXAU\n* If you have an issue with me posting this song or video please contact me through email or the YouTube private messaging system. Once I have received your message and determined you are the proper owner of this content I will have it removed!\n* Want to submit your videos? Send us your video links via email and we'll put them in our compilations! \nEMAIL: trthanh182@gmail.com\n* Don't forget like, comment and share the best cute funny videos for your family and friends. Thanks you !!\n Suscribete for more videos: https://goo.gl/s8m8LJ",
                    "title" : "IF YOU LAUGH YOU LOSE Compilation Funny cats and dogs Cute funny Pets 2018 #33",
                ],
                "publishedAt" : "2018-06-09T07:00:02.000Z",
                "tags" : [
                    "the pet collective 2018",
                    "best pets videos 2018",
                    "pets videos 2018",
                    "new pets videos",
                    "viral pet videos",
                    "viral animal videos",
                    "animals youtube",
                    "pets",
                    "funny dog videos",
                    "cute dog videos",
                    "funny cat videos",
                    "cute cat videos",
                    "cats",
                    "dogs",
                    "puppy",
                    "kittens",
                    "birds",
                    "crazy birds videos",
                    "newest pet videos",
                    "funny animal videos",
                    "cute funny pets",
                    "cute funny dogs",
                    "cute funny cats",
                    "cute funny animals",
                    "try not to laugh",
                    "if you laugh you lose",
                    "funny fails animals",
                    "funny fails compilations",
                    "Life Funny"
                ],
                "thumbnails" : [
                    "default" : [
                        "height" : 90,
                        "url" : "https://i.ytimg.com/vi/g55ZqyCSUHg/default.jpg",
                        "width" : 120,
                    ],
                    "high" : [
                        "height" : 360,
                        "url" : "https://i.ytimg.com/vi/g55ZqyCSUHg/hqdefault.jpg",
                        "width" : 480,
                    ],
                    "medium" : [
                        "height" : 180,
                        "url" : "https://i.ytimg.com/vi/g55ZqyCSUHg/mqdefault.jpg",
                        "width" : 320,
                    ],
                ],
                "title" : "IF YOU LAUGH YOU LOSE Compilation Funny cats and dogs Cute funny Pets 2018 #33",
            ]
        ]
    }
    
}
