//
//  YoutubeSearchViewController.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/7/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class YoutubeSearchViewController: UIViewController {
    
    @IBOutlet weak var searchHeaderView: SearchHeaderView!
    @IBOutlet var searchTableView: UITableView!
    
    private let service = GTLRYouTubeService()
    private var videoData: [YouTubeVideo] = []
    private var searchQueryString = ""
    private var closeKeyboardTapRecognizer: UITapGestureRecognizer!
    
    private let dataManager = DataManager()
    
    private let numEmptyVideos = 3
    private let numVideos: UInt = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // want to set UITapGestureRecognizer to a private variable so we can add/remove the same one as needed
        closeKeyboardTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchButtonPressed))
        closeKeyboardTapRecognizer.isAccessibilityElement = false
        
        // need to set the delegate for the header to see if the search button was pressed
        searchHeaderView.searchHeaderDelegate = self
        // need to set the delegate method of the search text field to get the query string and to search
        searchHeaderView.searchTextField.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        // need to set the API Key for the google service to complete requests
        service.apiKey = Constants.googleAPIKey
    }
    
    func addHideKeyboardGesture() {
        view.addGestureRecognizer(closeKeyboardTapRecognizer)
    }
    
    func removeHideKeyboardGesture() {
        view.removeGestureRecognizer(closeKeyboardTapRecognizer)
    }
    
    func showActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // start animation on all visible cells
    func animateCells() {
        for cell in searchTableView.visibleCells {
            if let videoCell = cell as? YoutubeSearchResultTableViewCell {
                videoCell.setEmptyBackground()
                videoCell.startAnimation()
            }
        }
    }
    
    // stop animation on all visible cells
    func stopAnimateCells() {
        for cell in searchTableView.visibleCells {
            if let videoCell = cell as? YoutubeSearchResultTableViewCell {
                videoCell.endAnimation()
            }
        }
    }
    
    func showEmptyResultSet() {
        showAlert(title: "No Results", message: "Sorry, youtube couldn't find any videos with your search \(searchQueryString).")
    }
}

// MARK: Youtube API calls

extension YoutubeSearchViewController {
    
    // Make initial search request with query string from user
    func fetchSearchResource() {
        // Need to make sure we have a connection before we search
        if dataManager.hasConnection() {
            // show loading and activity
            showActivityIndicator()
            animateCells()
            // build up google query with required parameters
            let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
            query.maxResults = numVideos
            query.order = kGTLRYouTubeOrderRating
            query.q = searchQueryString
            
            // execute query with callback
            service.executeQuery(query,
                                 delegate: self,
                                 didFinish: #selector(searchResultWithTicket(ticket:finishedWithObject:error:)))
        }
        else {
            showAlert(title: "No Internet Connection", message: "There appears to be no internet conncetion. Please make sure you have an active internet connection.")
        }
    }
    
    // Process the response and make the subsequent video call to get more data that we need to display (like contentDetails)
    @objc func searchResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_SearchListResponse,
        error : NSError?) {
        
        // handle and show error if we got one from the initial search
        if let error = error {
            hideActivityIndicator()
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        // unwrap search results and make sure we have results to then pass on to the video list query
        if let searchResults = response.items, !searchResults.isEmpty {
            // VideosList query is needed to get contentDetails of the video for duration. We build up call here
            let videoQuery = GTLRYouTubeQuery_VideosList.query(withPart: "snippet,contentDetails")
            videoQuery.maxResults = numVideos
            // getting id's of all of the videos returned from the Search query to tell the VideosList query which videos we need data for
            let videoIds = searchResults.compactMap { return $0.identifier?.videoId }
            videoQuery.identifier = videoIds.joined(separator: ",")
            
            // execute query with callback
            service.executeQuery(videoQuery,
                                 delegate: self,
                                 didFinish: #selector(videoResultWithTicket(ticket:finishedWithObject:error:)))
        }
        // only way we'd get here is if the search query did not return any items, should never happen but let's account for it
        stopAnimateCells()
        hideActivityIndicator()
        if let searchResults = response.items, searchResults.isEmpty {
            showEmptyResultSet()
        }
    }
    
    // Process the response, set videoData and reload the table with our results
    @objc func videoResultWithTicket(ticket: GTLRServiceTicket,
                                     finishedWithObject response : GTLRYouTube_VideoListResponse,
                                     error : NSError?) {
        
        // handle and show error if we got one from the initial search
        if let error = error {
            hideActivityIndicator()
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        // unwrap video results and make sure we have to use later
        if let videoResults = response.items, !videoResults.isEmpty {
            // let's put all the videos we got from VideoListQuery into our videoData array with models that we control (YoutubeVideo)
            videoData = videoResults.compactMap {
                do {
                    // try to map GTLRYouTube_Video to YouTubeVideo so we can control the model
                    return try YouTubeVideo.buildWithYouTubeVideoResponse(youtubeVideo: $0)
                }
                catch let error {
                    hideActivityIndicator()
                    // some debugging information
                    print("Got error when trying to create YouTubeVideo with Video Response object: \(error.localizedDescription)")
                    return nil
                }
            }
        }
            // only way we'd get here is if the video list query did not return any items, should never happen but let's account for it
        else if let videoResults = response.items, videoResults.isEmpty {
            showEmptyResultSet()
        }
        hideActivityIndicator()
        // reload tableview with search results
        searchTableView.reloadData()
    }
    
}

// MARK: UITableViewDataSource methods

extension YoutubeSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if we do not have any videoData, we want to build an empty ghoul state of where videos will go
        if videoData.count == 0 {
            tableView.allowsSelection = false
            // build empty cell
            return YoutubeSearchResultTableViewCell.buildEmpty()
        }
        tableView.allowsSelection = true
        // get video and build cell with that data
        let video = videoData[indexPath.row]
        let cell = YoutubeSearchResultTableViewCell.buildWithVideo(video: video)
        cell.endAnimation()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // want to show at least numEmptyVideos when we don't have data
        return videoData.count > 0 ? videoData.count : numEmptyVideos
    }
}

// MARK: UITableViewDelegate methods

extension YoutubeSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < videoData.count { // indexPath.row should never be greater than videoData.count, putting just in case
            let video = videoData[indexPath.row]
            // when we select a video, build up the video player with that video
            let videoPlayerViewController = VideoPlayerViewController.buildWithVideo(video: video)
            tableView.deselectRow(at: indexPath, animated: true)
            present(videoPlayerViewController, animated: true)
        }
    }
    
}

// MARK: UITextFieldDelegate methods

extension YoutubeSearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addHideKeyboardGesture()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        removeHideKeyboardGesture()
        // Do not want to make an API call if the query string is empty or the same
        if !searchText.isEmpty && searchQueryString != searchText {
            searchQueryString = searchText
            fetchSearchResource()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: SearchHeaderDelegate method

extension YoutubeSearchViewController: SearchHeaderDelegate {
    
    @objc func searchButtonPressed() {
        if searchHeaderView.searchTextField.isFirstResponder {
            searchHeaderView.searchTextField.resignFirstResponder()
        }
    }
    
}
