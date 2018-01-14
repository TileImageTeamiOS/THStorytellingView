//
//  VideoContentView.swift
//  ScrollViewMarker
//
//  Created by Seong ho Hong on 2018. 1. 5..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

enum PlayStatus: Int {
    case play = 0
    case pause
}

enum VideoStatus: Int {
    case show = 0
    case hide
}

public class VideoContentView: UIView {
    private var videoTapGestureRecognizer = UITapGestureRecognizer()
    private var videoPanGestureRecognizer = UIPanGestureRecognizer()
    var player =  AVPlayer()
    var playStatus = PlayStatus.pause
    var videoStatus = VideoStatus.show
    var fullscreenButton = UIButton()
    var videoButton = UIButton()
    var topVC = UIApplication.shared.keyWindow?.rootViewController
    
    func setVideoPlayer() {
        videoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoViewTap(_:)))
        videoPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(videoViewPan(_:)))
        videoPanGestureRecognizer.delegate = self
        
        self.addGestureRecognizer(videoTapGestureRecognizer)
        self.addGestureRecognizer(videoPanGestureRecognizer)
        self.backgroundColor = UIColor.black
        
        // 전체화면 버튼 세팅
        fullscreenButton.frame = CGRect(x: self.frame.width - 30, y: self.frame.height - 30, width: 20, height: 20)
        fullscreenButton.layer.cornerRadius = 3
        fullscreenButton.layer.opacity = 0.5
        fullscreenButton.setImage(UIImage(named: "enlarge.png"), for: .normal)
        fullscreenButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        fullscreenButton.addTarget(self, action: #selector(pressfullscreenButton(_ :)), for: .touchUpInside)
        
        // 플레이 버튼 세팅
        videoButton.frame = CGRect(x: self.frame.width/2 - 25, y: self.frame.height/2 - 25, width: 50, height: 50)
        videoButton.layer.cornerRadius = 3
        videoButton.layer.opacity = 0.5
        videoButton.setImage(UIImage(named: "playBtn.png"), for: .normal)
        videoButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        videoButton.addTarget(self, action: #selector(pressVideoButton(_ :)), for: .touchUpInside)
    }
    
    func setVideo(url: URL) {
        player =  AVPlayer(url: url)
        player.allowsExternalPlayback = false
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = self.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        self.layer.addSublayer(layer)
        self.addSubview(fullscreenButton)
        self.addSubview(videoButton)
    }
    
    func playVideo() {
        playStatus = .play
        videoButton.setImage(UIImage(named: "pauseBtn.png"), for: .normal)
        player.play()
        
        hideStatus()
    }
    
    func pauseVideo() {
        playStatus = .pause
        videoButton.setImage(UIImage(named: "playBtn.png"), for: .normal)
        player.pause()
    }
    
    func hideStatus() {
        fullscreenButton.isHidden = true
        videoButton.isHidden = true
        videoStatus = .show
    }
    
    func showStatus() {
        fullscreenButton.isHidden = false
        videoButton.isHidden = false
        videoStatus = .hide
    }
    
    @objc func pressVideoButton(_ sender: UIButton!) {
        if playStatus == .pause {
            playVideo()
        } else {
            pauseVideo()
        }
    }
    
    @objc func pressfullscreenButton(_ sender: UIButton!) {
        let playerViewController = AVPlayerViewController()
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.player = player
        
        self.parentViewController?.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension VideoContentView: UIGestureRecognizerDelegate {
    @objc func videoViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if videoStatus == .show {
            showStatus()
        } else {
            hideStatus()
        }
    }
    
    @objc func videoViewPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        
        if abs(translation.x) > abs(translation.y) { // Horizontal pan
            let changedX = self.center.x + translation.x
            if changedX >= (self.superview?.frame.width)!/2 {
                self.center = CGPoint(x: changedX, y: self.center.y)
            }
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
        
        if gestureRecognizer.state == .ended {
            if self.center.x >= (self.superview?.frame.width)!/2 + (self.superview?.frame.width)!/4 {
                self.center = CGPoint(x: (self.superview?.frame.width)! + self.frame.width/3  , y: self.center.y)
            } else {
                self.center = CGPoint(x: (self.superview?.frame.width)!/2 , y: self.center.y)
            }
        }
    }
}

