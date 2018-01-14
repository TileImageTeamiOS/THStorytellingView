//
//  MarkerView.swift
//  ScrollViewMarker
//
//  Created by Seong ho Hong on 2018. 1. 1..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

public class MarkerView: UIView {
    fileprivate var dataSource: MarkerViewDataSource!
    var x = CGFloat()
    var y = CGFloat()
    var zoomScale = CGFloat()
    var imageView: UIImageView?
    var num = 0
    
    private var markerTapGestureRecognizer = UITapGestureRecognizer()
    
    private var isTitleContent = false
    private var isAudioContent = false
    private var isVideoContent = false
    private var isTextContent = false
    
    private var destinationRect = CGRect()
    
    var videoURL: URL?
    var audioURL: URL?
    var title: String?
    var textTitle: String?
    var textLink: String?
    var textContent: String?
    var isSelected = false
    
    public func set(dataSource: MarkerViewDataSource, x: CGFloat, y: CGFloat, zoomScale: CGFloat, isTitleContent: Bool, isAudioContent: Bool, isVideoContent: Bool, isTextContent: Bool) {
        // marker 위치 설정후 scrollview에 추가
        self.dataSource = dataSource
        self.x = x
        self.y = y
        self.zoomScale = zoomScale
        dataSource.scrollView.addSubview(self)
        
        // zoom 했을떄 위치 설정
        destinationRect.size.width = dataSource.scrollView.frame.width/zoomScale
        destinationRect.size.height = dataSource.scrollView.frame.height/zoomScale
        destinationRect.origin.x = x - destinationRect.size.width/2
        destinationRect.origin.y = y - destinationRect.size.height/2
        
        // marker tap 설정
        markerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(markerViewTap(_:)))
        markerTapGestureRecognizer.delegate = self
        self.addGestureRecognizer(markerTapGestureRecognizer)
        
        // content 존재 여부 설정
        self.isTitleContent = isTitleContent
        self.isAudioContent = isAudioContent
        self.isVideoContent = isVideoContent
        self.isTextContent = isTextContent
        
        num = UserDefaults.standard.integer(forKey: "integerKeyName")
        UserDefaults.standard.set(num+1, forKey: "integerKeyName")
    }
    
    // marker image 설정
    func setMarkerImage(markerImage: UIImage) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        imageView?.contentMode =  UIViewContentMode.scaleAspectFill
        imageView?.image = markerImage
        self.addSubview(imageView!)
    }
    
    // 비디오 url 설정
    func setVideoContent(url: URL) {
        videoURL = url
    }
    
    // 오디오 url 설정
    func setAudioContent(url: URL) {
        audioURL = url
    }
    
    // title string 설정
    func setTitle(title: String) {
        self.title = title
    }
    
    // text string 설정
    func setText(title: String, link: String, content: String) {
        self.textTitle = title
        self.textLink = link
        self.textContent = content
    }
    
    // 마커 클릭식, contentView set
    private func markerContentSet() {
        // content 존재 여부에 따라 view Hidden 결정
        if isTitleContent {
            dataSource.titleLabelView?.text = title
            dataSource.titleLabelView?.sizeToFit()
            dataSource.titleLabelView?.isHidden = false
            dataSource.titleLabelView?.center = (self.superview?.center)!
        }
        
        if isAudioContent {
            dataSource.audioContentView?.setAudio(url: audioURL!)
            dataSource.audioContentView?.isHidden = false
        }
        
        if isVideoContent {
            dataSource.videoContentView?.setVideo(url: videoURL!)
            dataSource.videoContentView?.isHidden = false
        }
        
        if isTextContent {
            dataSource.textContentView?.labelSet(title: textTitle, link: textLink, text: textContent)
            dataSource.textContentView?.frameSet(upY: (self.superview?.frame.height)!*(2/3), downY: (self.superview?.frame.height)!*(1/5))
            dataSource.textContentView?.isHidden = false
        }
    }
}

extension MarkerView: UIGestureRecognizerDelegate {
    @objc func markerViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if isSelected == false {
            dataSource.zoom(destinationRect: destinationRect)
            markerContentSet()
            isSelected = true
            let number:[String: Any] = ["num":num]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showMarker"), object: nil, userInfo: number)
        }
    }
}

