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
    private var videoData: [GTLRYouTube_Video] = []
    private var searchQueryString = ""
    
    private let numEmptyVideos = 3
    private let numVideos: UInt = 10
    
    private let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(searchButtonPressed))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchHeaderView.searchHeaderDelegate = self
        searchHeaderView.searchTextField.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        service.apiKey = apiKey
        
        view.addGestureRecognizer(hideKeyboardGesture)
    }
    
    // Make initial search request with query string from user
    func fetchSearchResource() {
        startAnimatingEmptyCells()
        view.removeGestureRecognizer(hideKeyboardGesture)
        let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
        query.maxResults = numVideos
        query.q = searchQueryString.escape()
        
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(searchResultWithTicket(ticket:finishedWithObject:error:)))
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
            videoData = videoResults
        }
        searchTableView.reloadData()
    }
    
    func startAnimatingEmptyCells() {
        for index in 0..<numEmptyVideos {
            if let emptyCell = tableView(searchTableView, cellForRowAt: IndexPath.init(row: index, section: 0)) as? YoutubeSearchResultTableViewCell {
                emptyCell.startAnimation()
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        searchQueryString = searchText
        // Do not want to make an API call if the query string is empty
        if !searchQueryString.isEmpty {
            fetchSearchResource()
        }
        // TODO-Remove
        //showAlert(title: "GO TO SEARCH", message: "GO SEARCH FOR \(searchText)")
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
