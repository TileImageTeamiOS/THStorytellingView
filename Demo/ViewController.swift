//
//  ViewController.swift
//  Demo
//
//  Created by Seong ho Hong on 2018. 1. 14..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import THTiledImageView

class ViewController: UIViewController {
    @IBOutlet weak var tileImageScrollView: THTiledImageScrollView!
    var tileImageDataSource: THTiledImageViewDataSource?
    
    // image info
    var imageSize = CGSize()
    var imageName = "shopping"
    var imageExtension = "jpg"
    var thumbnailName = "shoppingSmall"
    var thumbnailExtension = "jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // image cut info
        let tiles: [CGSize] = [CGSize(width: 2048, height: 2048), CGSize(width: 1024, height: 1024),
                               CGSize(width: 512, height: 512), CGSize(width: 256, height: 256),
                               CGSize(width: 128, height: 128)]
        UIImage.saveTileOf(size: tiles, name: imageName, withExtension: imageExtension)
        
        // image 설정
        let image = UIImage(named: imageName + "." + imageExtension)
        imageSize = CGSize(width: (image?.size.width)!, height: (image?.size.height)!)
        let thumbnailImageURL = Bundle.main.url(forResource: thumbnailName , withExtension: thumbnailExtension)!
        
        // set tile image
        setupExample(imageSize: imageSize, tileSize: tiles, imageURL: thumbnailImageURL)
    }
    
    func setupExample(imageSize: CGSize, tileSize: [CGSize], imageURL: URL) {
        tileImageDataSource = MyTileImageViewDataSource(imageSize: imageSize, tileSize: tileSize, imageURL: imageURL)
        
        tileImageDataSource?.delegate = self
        tileImageDataSource?.thumbnailImageName = imageName
        
        // 줌을 가장 많이 확대한 수준
        tileImageDataSource?.maxTileLevel = 5
        
        // 줌이 가장 확대가 안 된 수준
        tileImageDataSource?.minTileLevel = 1
        tileImageDataSource?.maxZoomLevel = 8
        tileImageDataSource?.imageExtension = imageExtension
        tileImageScrollView.set(dataSource: tileImageDataSource!)
        
        tileImageDataSource?.requestBackgroundImage { _ in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: THTiledImageScrollViewDelegate {
    
    func didScroll(scrollView: THTiledImageScrollView) {
    }
    
    func didZoom(scrollView: THTiledImageScrollView) {
    }
}

