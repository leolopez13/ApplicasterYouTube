//
//  YoutubeSearchResultTableViewCell.swift
//  YoutubeSearcher
//
//  Created by Lopez, Leonard on 6/8/18.
//  Copyright © 2018 Leonard Lopez. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import ImageLoader

class YoutubeSearchResultTableViewCell : UITableViewCell, ClassNameNibLoadable {
    
    static let NibName = "YoutubeSearchResultTableViewCell"
    
    var video: GTLRYouTube_Video?
    
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var videoTitleLabel: UILabel!
    @IBOutlet var videoDurationLabel: UILabel!
    @IBOutlet var playlistTitleLabel: UILabel!
    @IBOutlet var publishDateLabel: UILabel!
    
    var timer: Timer?
    
    let animationDuration = 0.1
    
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
    
    func animateToWhite() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.thumbnailImageView.layer.backgroundColor = UIColor.white.cgColor
            self.videoTitleLabel.layer.backgroundColor = UIColor.white.cgColor
            self.playlistTitleLabel.layer.backgroundColor = UIColor.white.cgColor
            self.videoDurationLabel.layer.backgroundColor = UIColor.white.cgColor
            self.publishDateLabel.layer.backgroundColor = UIColor.white.cgColor
        })
    }
    
    func setEmptyBackground() {
        thumbnailImageView.backgroundColor = UIColor.soapStoneGrey()
        videoTitleLabel.backgroundColor = UIColor.soapStoneGrey()
        playlistTitleLabel.backgroundColor = UIColor.soapStoneGrey()
        videoDurationLabel.backgroundColor = UIColor.soapStoneGrey()
        publishDateLabel.backgroundColor = UIColor.soapStoneGrey()
    }
    
    func removeEmptyBackground() {
        thumbnailImageView.backgroundColor = UIColor.clear
        videoTitleLabel.backgroundColor = UIColor.clear
        playlistTitleLabel.backgroundColor = UIColor.clear
        videoDurationLabel.backgroundColor = UIColor.clear
        publishDateLabel.backgroundColor = UIColor.clear
    }
    
    func fillVideoData() {
        guard let video = video else { return }
        
        if let thumbnailURLString = video.snippet?.thumbnails?.medium?.url,
            let thumbnailURL = URL(string: thumbnailURLString) {
            thumbnailImageView.load.request(with: thumbnailURL)
        }
        videoTitleLabel.text = video.snippet?.title
        playlistTitleLabel.text = video.snippet?.channelTitle
        videoDurationLabel.text = formatDuration(duration: video.contentDetails?.duration)
        publishDateLabel.text = video.snippet?.publishedAt?.date.dateToStringShort()
    }
    
    func formatDuration(duration: String? = "") -> String {
        //PT15M51S
        guard let duration = duration else { return "" }
        var durationString = duration.replacingOccurrences(of: "PT", with: "")
        durationString = durationString.replacingOccurrences(of: "S", with: "")
        
        var minutes = 0
        var seconds = 0
        
        // duration is unaltered string so we can test against this one having these values
        if duration.contains("M") && duration.contains("S") {
            let minutesAndSeconds = durationString.split(separator: "M")
            guard let unwrappedMinutes = Int(minutesAndSeconds[0]),
                let unwrappedSeconds = Int(minutesAndSeconds[1]) else {
                    return ""
            }
            minutes = unwrappedMinutes
            seconds = unwrappedSeconds
        }
        else if duration.contains("M") {
            guard let unwrappedMinutes = Int(durationString.replacingOccurrences(of: "M", with: "")) else { return "" }
            minutes = unwrappedMinutes
        }
        else if duration.contains("S") {
            guard let unwrappedSeconds = Int(durationString) else { return "" }
            seconds = unwrappedSeconds
        }
        
        let displayMinutes = minutes % 60
        let hours = minutes / 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, displayMinutes, seconds)
        }
        else {
            return String(format: "%d:%02d", displayMinutes, seconds)
        }
    }
    
    func startAnimation() {
        timer = Timer.init(fireAt: Date(), interval: animationDuration * 2, target: self, selector: #selector(animateToGrey), userInfo: nil, repeats: true)
        guard let timer = timer else { return }
        removeEmptyBackground()
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
    }
    
    func endAnimation() {
        guard let timer = timer else { return }
        timer.invalidate()
    }
    
    static func buildWithVideo(video: GTLRYouTube_Video) -> YoutubeSearchResultTableViewCell {
        let videoResultView = YoutubeSearchResultTableViewCell.loadInstanceFromNib()
        videoResultView.video = video
        videoResultView.stylize()
        videoResultView.removeEmptyBackground()
        videoResultView.fillVideoData()
        return videoResultView
    }
    
    static func buildEmpty() -> YoutubeSearchResultTableViewCell {
        let videoResultView = YoutubeSearchResultTableViewCell.loadInstanceFromNib()
        videoResultView.stylize()
        videoResultView.setEmptyBackground()
        return videoResultView
    }
}
