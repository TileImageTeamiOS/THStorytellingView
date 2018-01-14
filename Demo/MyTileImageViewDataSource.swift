//
//  MyTileImageViewDataSource.swift
//  Demo
//
//  Created by Seong ho Hong on 2018. 1. 14..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import THTiledImageView

class MyTileImageViewDataSource: THTiledImageViewDataSource {
    var delegate: THTiledImageScrollViewDelegate?
    
    
    var minTileLevel: Int
    var maxTileLevel: Int
    
    var tileSize: [CGSize]
    
    var thumbnailImageName: String = ""
    var originalImageSize: CGSize
    
    var maxZoomLevel: CGFloat?
    var imageURL: URL
    var image: UIImage
    var imageExtension: String
    
    init(imageSize: CGSize, tileSize: [CGSize], imageURL: URL) {
        self.originalImageSize = imageSize
        self.tileSize = tileSize
        self.imageURL = imageURL
        self.image = UIImage()
        self.maxTileLevel = tileSize.count
        self.minTileLevel = 1
        self.imageExtension = "jpg"
    }
    
    func requestBackgroundImage(completion: @escaping (UIImage?) -> Void) {
        
        if imageURL.absoluteString.hasPrefix("https") {
            // Server
            let session = URLSession(configuration: .default)
            let request = URLRequest(url: imageURL)
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                guard error == nil else { return }
                guard let response = response as? HTTPURLResponse else { return }
                
                switch response.statusCode {
                case 200:
                    if let data = data, let image = UIImage(data: data) {
                        self.image = image
                        completion(self.image)
                    }
                default:
                    completion(nil)
                }
            }
            dataTask.resume()
        } else {
            // Local
            self.image = UIImage(contentsOfFile: imageURL.path)!
            completion(self.image)
        }
        
    }
    
}

