//
//  YoutubeSearcherUITests.swift
//  YoutubeSearcherUITests
//
//  Created by Lopez, Leonard on 6/7/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import XCTest

class YoutubeSearcherUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // want to test that we can query the Youtube API with a search term
    func testSearching() {
        let app = XCUIApplication()
        let searchField = app.searchFields["Search youtube videos"]
        // want to make sure this matches the number of empty views that we should have
        XCTAssertEqual(app.tables.staticTexts.matching(identifier: "Search Result").count, 3, "Check the amount of empty video cells is 3")
        searchField.tap()
        // type search query text
        searchField.typeText("funny cats")
        // make request to youtube
        app.buttons["Search Button"].tap()
        // wait for response
        let searchResults = app.tables.staticTexts.matching(identifier: "Search Result")
        let countPredicate = NSPredicate(format: "count == 10")
        expectation(for: countPredicate, evaluatedWith: searchResults, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        // want to make sure this matches the number of video result views that we should have
        XCTAssertEqual(app.tables.staticTexts.matching(identifier: "Search Result").count, 10, "Check the amount of loaded video cells is 10 after making request")
    }
    
    // want to test that we can still query the Youtube API with a search term and then play a video from that result in the youtube player
    func testPlayVideo() {
        let app = XCUIApplication()
        let searchField = app.searchFields["Search youtube videos"]
        searchField.tap()
        // type search query text
        searchField.typeText("funny cats")
        // make request to youtube
        app.buttons["Search Button"].tap()
        // wait for response
        let searchResults = app.tables.staticTexts.matching(identifier: "Search Result")
        let countPredicate = NSPredicate(format: "count == 10")
        expectation(for: countPredicate, evaluatedWith: searchResults, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        // tap first video once we get results
        searchResults.firstMatch.tap()
        
        let loadingVideo = app.staticTexts["Video Loading View"]
        //let youtubeVideoPlayerView = app.staticTexts["Youtube Video Player"]
        let youtubeVideoPlayerView = app.otherElements.matching(identifier: "Youtube Video Player").firstMatch
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate, evaluatedWith: loadingVideo, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // if we have a loading view, we should have a youtube player video view also
        XCTAssert(app.staticTexts["Video Loading View"].exists, "Want to make sure video loading screen is showing when the view shows")
        expectation(for: existsPredicate, evaluatedWith: youtubeVideoPlayerView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(youtubeVideoPlayerView.exists, "Want to make sure youtube video player is also available to load when the video starts")
    }
}
