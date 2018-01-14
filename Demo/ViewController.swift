//
//  ViewController.swift
//  Demo
//
//  Created by Seong ho Hong on 2018. 1. 14..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import THTiledImageView
import THScrollView_minimap

class ViewController: UIViewController {
    //THTileImgeView set
    @IBOutlet weak var tileImageScrollView: THTiledImageScrollView!
    var tileImageDataSource: THTiledImageViewDataSource?
    
    //THScrollView minimap set
    @IBOutlet weak var minimapView: THMinimapView!
    var minimapDataSource: THMinimapDataSource?
    
    //THScrollView content set
    var audioContentView = AudioContentView()
    var videoContentView = VideoContentView()
    var textContentView = TextContentView()
    var titleLabel = UILabel()
    var markerDataSource: MarkerViewDataSource!
    
     var markerArray = [MarkerView]()
    
    //THEditor set
    var centerPoint = UIView()
    
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
        let thumbnailImage = UIImage(contentsOfFile: thumbnailImageURL.path)!
        
        // set tile image
        setupTileImage(imageSize: imageSize, tileSize: tiles, imageURL: thumbnailImageURL)
        
        // set minimap
        setupMinimap(thumbnailImage: thumbnailImage)
        
        // set contentView
        setupContentView()
        
        // set markerView
        setupMarkerView()
    }
    
    func setupTileImage(imageSize: CGSize, tileSize: [CGSize], imageURL: URL) {
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
    
    func setupMinimap(thumbnailImage: UIImage) {
        minimapDataSource = MyMinimapDataSource(scrollView: tileImageScrollView, thumbnailImage: thumbnailImage , originImageSize: imageSize)
        
        minimapDataSource?.borderColor = UIColor.red
        minimapDataSource?.borderWidth = 2.0
        minimapDataSource?.downSizeRatio = 5 * thumbnailImage.size.width / view.frame.width
        minimapView.set(dataSource: minimapDataSource!)
    }
    
    func setupContentView() {
        // title contentView 설정
        titleLabel.center = self.view.center
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font.withSize(20)
        self.view.addSubview(titleLabel)
        
        // audio contentView 설정
        audioContentView.frame = CGRect(x: 0, y: 200, width: 80, height: 80)
        self.view.addSubview(audioContentView)
        
        // video contentview 설정
        videoContentView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
        self.view.addSubview(videoContentView)
        
        // text contentView 설정
        textContentView.frame = CGRect(x: 0, y: self.view.frame.height - 80, width: self.view.frame.width, height: 100)
        self.view.addSubview(textContentView)
    }
    
    func setupMarkerView() {
        var ratio:Double = 200
        if imageSize.height > imageSize.width {
            ratio = Double(imageSize.height) / 40
        } else {
            ratio = Double(imageSize.width) / 40
        }
        
        // markerData Source 설정
        markerDataSource = MarkerViewDataSource(scrollView: tileImageScrollView, imageSize: imageSize, ratioByImage: ratio, titleLabelView: titleLabel, audioContentView: audioContentView, videoContentView: videoContentView, textContentView: textContentView)
    }
    
    func setupEditor() {
        // edit center point 설정
        centerPoint.frame = CGRect(x: tileImageScrollView.frame.width/2 - 5 , y: tileImageScrollView.frame.height/2 + (self.navigationController?.navigationBar.frame.height)! - 15, width: CGFloat(10), height: CGFloat(10))
        centerPoint.backgroundColor = UIColor.red
        centerPoint.layer.cornerRadius = 5
        
        self.view.addSubview(centerPoint)
        centerPoint.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: THTiledImageScrollViewDelegate {
    
    func didScroll(scrollView: THTiledImageScrollView) {
        minimapDataSource?.resizeMinimapView(minimapView: minimapView)
    }
    
    func didZoom(scrollView: THTiledImageScrollView) {
    }
}

