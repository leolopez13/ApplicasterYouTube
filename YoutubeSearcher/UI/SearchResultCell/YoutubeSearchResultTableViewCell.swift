//
//  YoutubeSearchResultTableViewCell.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/8/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit
import ImageLoader

class YoutubeSearchResultTableViewCell : UITableViewCell, ClassNameNibLoadable {
    
    static let NibName = "YoutubeSearchResultTableViewCell"
    
    var video: YouTubeVideo?
    
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var videoTitleLabel: UILabel!
    @IBOutlet var videoDurationLabel: UILabel!
    @IBOutlet var playlistTitleLabel: UILabel!
    @IBOutlet var publishDateLabel: UILabel!
    
    var timer: Timer?
    
    let animationDuration = 0.5
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stylize()
    }
    
    func stylize() {
        thumbnailImageView.makeRounded()
        
        videoTitleLabel.makeRounded()
        videoTitleLabel.setDefaultFont(of: 16)
        
        playlistTitleLabel.makeRounded()
        playlistTitleLabel.setRegularFont(of: 14)
        
        videoDurationLabel.makeRounded()
        videoDurationLabel.setRegularFont(of: 12)
        
        publishDateLabel.makeRounded()
        publishDateLabel.setRegularFont(of: 11)
    }
    
    // animate all views to have grey background
    @objc func animateToGrey() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.thumbnailImageView.layer.backgroundColor = UIColor.soapStoneGrey().cgColor
            self.videoTitleLabel.layer.backgroundColor = UIColor.soapStoneGrey().cgColor
            self.playlistTitleLabel.layer.backgroundColor = UIColor.soapStoneGrey().cgColor
            self.videoDurationLabel.layer.backgroundColor = UIColor.soapStoneGrey().cgColor
            self.publishDateLabel.layer.backgroundColor = UIColor.soapStoneGrey().cgColor
        }, completion: { _ in
            self.animateToWhite()
        })
    }
    
    // animate all views to have white background
    func animateToWhite() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.thumbnailImageView.layer.backgroundColor = UIColor.white.cgColor
            self.videoTitleLabel.layer.backgroundColor = UIColor.white.cgColor
            self.playlistTitleLabel.layer.backgroundColor = UIColor.white.cgColor
            self.videoDurationLabel.layer.backgroundColor = UIColor.white.cgColor
            self.publishDateLabel.layer.backgroundColor = UIColor.white.cgColor
        })
    }
    
    // create default empty state for views
    func setEmptyBackground() {
        thumbnailImageView.image = nil
        thumbnailImageView.backgroundColor = UIColor.soapStoneGrey()
        videoTitleLabel.text = nil
        videoTitleLabel.backgroundColor = UIColor.soapStoneGrey()
        playlistTitleLabel.text = nil
        playlistTitleLabel.backgroundColor = UIColor.soapStoneGrey()
        videoDurationLabel.text = nil
        videoDurationLabel.backgroundColor = UIColor.soapStoneGrey()
        publishDateLabel.text = nil
        publishDateLabel.backgroundColor = UIColor.soapStoneGrey()
    }
    
    // set all views to have clear color and remove the grey empty background once we have data
    func removeEmptyBackground() {
        thumbnailImageView.backgroundColor = UIColor.clear
        videoTitleLabel.backgroundColor = UIColor.clear
        playlistTitleLabel.backgroundColor = UIColor.clear
        videoDurationLabel.backgroundColor = UIColor.clear
        publishDateLabel.backgroundColor = UIColor.clear
    }
    
    // now that we have a video, load all the corresponding view data
    func fillVideoData() {
        guard let video = video else { return }
        
        thumbnailImageView.load.request(with: video.thumbnailURL)
        videoTitleLabel.text = video.title
        playlistTitleLabel.text = video.playlistTitle
        videoDurationLabel.text = video.duration
        publishDateLabel.text = video.publishDate
    }
    
    // start a timer that repeats until it will be invalidated to load the animation
    func startAnimation() {
        timer = Timer.init(fireAt: Date(), interval: animationDuration * 2, target: self, selector: #selector(animateToGrey), userInfo: nil, repeats: true)
        guard let timer = timer else { return }
        removeEmptyBackground()
        // need to add the timer to the run loop with the way it was instantiated
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
    }
    
    // invalidate the timer that is animating the views
    func endAnimation() {
        guard let timer = timer else { return }
        timer.invalidate()
    }
    
    static func buildWithVideo(video: YouTubeVideo) -> YoutubeSearchResultTableViewCell {
        let videoResultViewCell = YoutubeSearchResultTableViewCell.loadInstanceFromNib()
        videoResultViewCell.video = video
        videoResultViewCell.stylize()
        videoResultViewCell.removeEmptyBackground()
        videoResultViewCell.fillVideoData()
        return videoResultViewCell
    }
    
    static func buildEmpty() -> YoutubeSearchResultTableViewCell {
        let videoResultViewCell = YoutubeSearchResultTableViewCell.loadInstanceFromNib()
        videoResultViewCell.stylize()
        videoResultViewCell.setEmptyBackground()
        return videoResultViewCell
    }
}
