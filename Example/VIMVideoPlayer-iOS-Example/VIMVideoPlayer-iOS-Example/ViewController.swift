//
//  ViewController.swift
//  VIMVideoPlayer-iOS-Example
//
//  Created by King, Gavin on 3/9/16.
//  Copyright © 2016 Gavin King. All rights reserved.
//

import UIKit

class ViewController: UIViewController, VIMVideoPlayerViewDelegate
{
    @IBOutlet weak var videoPlayerView: VIMVideoPlayerView!
    @IBOutlet weak var slider: UISlider!
    
    private var isScrubbing = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupVideoPlayerView()
        self.setupSlider()
    }
    
    // MARK: VIMVideoPlayerViewDelegate

    private func setupVideoPlayerView()
    {
        self.videoPlayerView.player.looping = true
        self.videoPlayerView.player.disableAirplay()
        self.videoPlayerView.setVideoFillMode(AVLayerVideoGravityResizeAspectFill)

        self.videoPlayerView.delegate = self
        
        if let path = NSBundle.mainBundle().pathForResource("field", ofType: "mp4")
        {
            self.videoPlayerView.player.setURL(NSURL(fileURLWithPath: path))
        }
        else
        {
            assertionFailure("Video file not found!")
        }
    }
    
    private func setupSlider()
    {
        self.slider.addTarget(self, action: "scrubbingDidStart", forControlEvents: UIControlEvents.TouchDown)
        self.slider.addTarget(self, action: "scrubbingDidChange", forControlEvents: UIControlEvents.ValueChanged)
        self.slider.addTarget(self, action: "scrubbingDidEnd", forControlEvents: UIControlEvents.TouchUpInside)
        self.slider.addTarget(self, action: "scrubbingDidEnd", forControlEvents: UIControlEvents.TouchUpOutside)
    }
    
    // MARK: Actions
    
    @IBAction func didTapPlayPauseButton(sender: UIButton)
    {
        if self.videoPlayerView.player.playing
        {
            sender.selected = true
            
            self.videoPlayerView.player.pause()
        }
        else
        {
            sender.selected = false

            self.videoPlayerView.player.play()
        }
    }
    
    // MARK: Scrubbing Actions
    
    func scrubbingDidStart()
    {
        self.isScrubbing = true
        
        self.videoPlayerView.player.startScrubbing()
    }
    
    func scrubbingDidChange()
    {
        guard let duration = self.videoPlayerView.player.player.currentItem?.duration
            where self.isScrubbing == true else
        {
            return
        }
        
        let time = Float(CMTimeGetSeconds(duration)) * self.slider.value
        
        self.videoPlayerView.player.scrub(time)
    }
    
    func scrubbingDidEnd()
    {
        self.videoPlayerView.player.stopScrubbing()
        
        self.isScrubbing = false
    }
    
    // MARK: VIMVideoPlayerViewDelegate
    
    func videoPlayerViewIsReadyToPlayVideo(videoPlayerView: VIMVideoPlayerView?)
    {
        self.videoPlayerView.player.play()
    }
    
    func videoPlayerView(videoPlayerView: VIMVideoPlayerView!, timeDidChange cmTime: CMTime)
    {
        guard let duration = self.videoPlayerView.player.player.currentItem?.duration
            where self.isScrubbing == false else
        {
            return
        }
        
        let totalTimeInSeconds = Float(CMTimeGetSeconds(duration))
        let currentTimeInSeconds = Float(CMTimeGetSeconds(cmTime))
        
        self.slider.value = currentTimeInSeconds / totalTimeInSeconds
    }
}