//
//  VideoPlayerViewController.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/8/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import FLAnimatedImage

class VideoPlayerViewController: UIViewController {
    
    private static let StoryboardName = "VideoPlayerStoryboard"
    
    @IBOutlet var youtubePlayerView: YTPlayerView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var loadingViewLoadingImageContainerView: UIView!
    
    var video: YouTubeVideo? = nil
    
    let dataManager = DataManager()
    
    static func buildWithVideo(video: YouTubeVideo) -> VideoPlayerViewController {
        let bundle = Bundle(for: VideoPlayerViewController.self)
        let storyboard =  UIStoryboard(name: StoryboardName, bundle: bundle)
        
        let controller = storyboard.instantiateInitialViewController() as! VideoPlayerViewController
        
        controller.video = video
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtubePlayerView.delegate = self
        
        guard let video = video else { return }
        
        // adding in gif to show while loading
        if let loadingGifURL = URL(string: "https://78.media.tumblr.com/2c34bd9b24641aaf7ae2c8b2847435fc/tumblr_nzwkbcWeYP1qhjjeao1_500.gif") {
            do {
                let gifURLData = try Data.init(contentsOf: loadingGifURL)
                let animatedImage = FLAnimatedImage.init(animatedGIFData: gifURLData)
                let animatedImageView = FLAnimatedImageView.init(frame: CGRect.init(x: 0, y: 0, width: loadingViewLoadingImageContainerView.width, height: loadingViewLoadingImageContainerView.height))
                animatedImageView.animatedImage = animatedImage
                animatedImageView.contentMode = .scaleAspectFill
                loadingViewLoadingImageContainerView.addSubview(animatedImageView)
            }
            catch let error {
                print("Got error: \(error.localizedDescription) - while trying to get data from contents of loading fig url")
            }
        }
        
        // once view did load, start loading video
        youtubePlayerView.load(withVideoId: video.id)
    }
    
    @IBAction func didPressCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension VideoPlayerViewController : YTPlayerViewDelegate {
    
    // once the player became ready and loaded the video we want to start playing it right away and remove the loading view
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        loadingView.isHidden = true
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .buffering:
            // show loading view while buffering video
            loadingView.isHidden = false
            break
        case .unstarted,
            .playing:
            // remove loading view while unstarted or playing
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
