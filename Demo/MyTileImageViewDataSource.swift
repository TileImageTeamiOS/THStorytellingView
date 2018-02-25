//
//  MyTileImageViewDataSource.swift
//  THTiledImageView
//
//  Created by 홍창남 on 2017. 12. 30..
//  Copyright © 2017년 홍창남. All rights reserved.
//

import UIKit
import THTiledImageView

class MyTileImageViewDataSource: THTiledImageViewDataSource {
    weak var delegate: THTiledImageScrollViewDelegate?
    var minTileLevel: Int
    var maxTileLevel: Int
    var tileSize: [CGSize]
    var thumbnailImageName: String = ""
    var originalImageSize: CGSize
    var maxZoomLevel: CGFloat?
    var backgroundImage: UIImage?
    var backgroundImageURL: URL?
    var imageExtension: String
    var tileImageBaseURL: URL?
    var accessFromServer: Bool
    var scrollViewSize: CGSize?
    
    init(tileImageBaseURL: URL? = nil, imageSize: CGSize, tileSize: [CGSize]) {
        if let tileImageBaseURL = tileImageBaseURL {
            self.tileImageBaseURL = tileImageBaseURL
            self.accessFromServer = true
        } else {
            self.accessFromServer = false
        }
        self.originalImageSize = imageSize
        self.tileSize = tileSize
        self.maxTileLevel = tileSize.count
        self.minTileLevel = 1
        self.imageExtension = "jpg"
    }
}
