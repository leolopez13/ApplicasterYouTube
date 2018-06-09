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
    
    private let apiKey = "AIzaSyDo4JaFczvX_Z5cqdfXwMf7fV7mnKdVLFw"
    private let service = GTLRYouTubeService()
    private var videoData: [YouTubeVideo] = []
    private var searchQueryString = ""
    private var closeKeyboardTapRecognizer: UITapGestureRecognizer!
    
    private let dataManager = DataManager()
    
    private let numEmptyVideos = 3
    private let numVideos: UInt = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeKeyboardTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchButtonPressed))
        
        searchHeaderView.searchHeaderDelegate = self
        searchHeaderView.searchTextField.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        service.apiKey = apiKey
    }
    
    func addHideKeyboardGesture() {
        view.addGestureRecognizer(closeKeyboardTapRecognizer)
    }
    
    func removeHideKeyboardGesture() {
        view.removeGestureRecognizer(closeKeyboardTapRecognizer)
    }
    
    // Make initial search request with query string from user
    func fetchSearchResource() {
        
        if dataManager.hasConnection() {
            animateCells()
            let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
            query.maxResults = numVideos
            query.order = kGTLRYouTubeOrderRating
            query.q = searchQueryString
            
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
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        if let searchResults = response.items, !searchResults.isEmpty {
            let videoQuery = GTLRYouTubeQuery_VideosList.query(withPart: "snippet,contentDetails")
            videoQuery.maxResults = numVideos
            let videoIds = searchResults.compactMap { return $0.identifier?.videoId }
            videoQuery.identifier = videoIds.joined(separator: ",")
            
            service.executeQuery(videoQuery,
                                 delegate: self,
                                 didFinish: #selector(videoResultWithTicket(ticket:finishedWithObject:error:)))
        }
    }
    
    // Process the response, set videoData and reload the table with our results
    @objc func videoResultWithTicket(ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_VideoListResponse,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        if let videoResults = response.items, !videoResults.isEmpty {
            videoData = videoResults.compactMap {
                do {
                    return try YouTubeVideo.buildWithYouTubeVideoResponse(youtubeVideo: $0)
                }
                catch {
                    return nil
                }
            }
        }
        searchTableView.reloadData()
    }
    
    func animateCells() {
        for cell in searchTableView.visibleCells {
            if let videoCell = cell as? YoutubeSearchResultTableViewCell {
                videoCell.setEmptyBackground()
                videoCell.startAnimation()
            }
        }
    }
}

// MARK: UITableViewDataSource methods

extension YoutubeSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if videoData.count == 0 {
            tableView.allowsSelection = false
            if let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyVideoCell") as? YoutubeSearchResultTableViewCell {
                return emptyCell
            }
            else {
                return YoutubeSearchResultTableViewCell.buildEmpty()
            }
        }
        tableView.allowsSelection = true
        let video = videoData[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as? YoutubeSearchResultTableViewCell {
            cell.endAnimation()
            return cell
        }
        let cell = YoutubeSearchResultTableViewCell.buildWithVideo(video: video)
        cell.endAnimation()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoData.count > 0 ? videoData.count : numEmptyVideos
    }
}

// MARK: UITableViewDelegate methods

extension YoutubeSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videoData[indexPath.row]
        let videoPlayerViewController = VideoPlayerViewController.buildWithVideo(video: video)
        present(videoPlayerViewController, animated: true)
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
        if !searchQueryString.isEmpty || searchQueryString != searchText {
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
