//
//  Marker.swift
//  Demo
//
//  Created by mac on 2018. 1. 30..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

public struct Marker {
    let xFloat: CGFloat
    let yFloat: CGFloat
    let zoomScale: CGFloat
    var _videoURL: URL?
    var _audioURL: URL?
    var _title: String?
    var _textTitle: String?
    var _textLink: String?
    var _textContent: String?

    init(xFloat: CGFloat, yFloat: CGFloat, zoomScale: CGFloat) {
        self.xFloat = xFloat
        self.yFloat = yFloat
        self.zoomScale = zoomScale
    }

    public var videoURL: URL? {
        get {return self._videoURL}
        set {self._videoURL = newValue}
    }
    
    public var audioURL: URL? {
        get {return self._audioURL}
        set {self._audioURL = newValue}
    }
    
    public var title: String? {
        get {return self._title}
        set {self._title = newValue}
    }
    
    public var textTitle: String? {
        get {return self._title}
        set {self._textTitle = newValue}
    }
    
    public var textLink: String? {
        get {return self._textLink}
        set {self._textLink = newValue}
    }
    
    public var textContent: String? {
        get {return self._textContent}
        set {self._textContent = newValue}
    }
}
