//
//  VideoPlayerViewController.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/8/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST

class VideoPlayerViewController: UIViewController {
    
    private static let StoryboardName = "VideoPlayerStoryboard"
    
    @IBOutlet var youtubePlayerView: YTPlayerView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var closeButton: UIButton!
    
    var video: GTLRYouTube_Video? = nil
    
    static func buildWithVideo(video: GTLRYouTube_Video) -> VideoPlayerViewController {
        let bundle = Bundle(for: VideoPlayerViewController.self)
        let storyboard =  UIStoryboard(name: StoryboardName, bundle: bundle)
        
        let controller = storyboard.instantiateInitialViewController() as! VideoPlayerViewController
        controller.video = video
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtubePlayerView.delegate = self
        
        guard let video = video, let videoId = video.identifier else { return }
        youtubePlayerView.load(withVideoId: videoId)
    }
    
    @IBAction func didPressCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension VideoPlayerViewController : YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        loadingView.isHidden = true
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .buffering:
            loadingView.isHidden = false
            break
        case .unstarted,
            .playing:
            loadingView.isHidden = true
            break
        case .ended:
            dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
}
