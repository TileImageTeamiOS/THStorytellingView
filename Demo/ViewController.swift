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
    var isEditor = false
    var isSelected = false
    var markerIndex = 0

    // image info
    var imageSize = CGSize()

    var thumbnailName = "overwatchthubnail"
    var thumbnailExtension = "jpg"

    var imageName: String = ""
    var imageExtension: String = ""
    var tiles: [CGSize] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let thumbnailImageURL = Bundle.main.url(forResource: thumbnailName , withExtension: thumbnailExtension)!
        let thumbnailImage = UIImage(contentsOfFile: thumbnailImageURL.path)!

        // image 설정
        if let image = UIImage(named: imageName + "." + imageExtension) {
            imageSize = CGSize(width: image.size.width, height: image.size.height)
            // set tile image
            setupTileImage(imageSize: imageSize, tileSize: tiles, imageURL: thumbnailImageURL)
        }

        // set minimap
        setupMinimap(thumbnailImage: thumbnailImage)

        // set contentView
        setupContentView()

        // set markerView
        setupMarkerView()

        // set editor
        setupEditor()

        // set marker control
        setupMarkerControl()
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
        textContentView.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height*(1/5), width: self.view.frame.width, height: self.view.frame.height*(1/5))
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

        // editor button 설정
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backBtn))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editor", style: .plain, target: self, action: #selector(editorBtn))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }

    // editor button 구현
    @objc func editorBtn() {
        if isSelected == false {
            if isEditor == false {
                self.navigationItem.rightBarButtonItem?.title = "Done"
                tileImageScrollView.layer.borderWidth = 4
                tileImageScrollView.layer.borderColor = UIColor.red.cgColor
                centerPoint.isHidden = isEditor
                isEditor = true
            } else {
                self.navigationItem.rightBarButtonItem?.title = "Editor"
                tileImageScrollView.layer.borderWidth = 0
                centerPoint.isHidden = isEditor
                isEditor = false

                let editorViewController = EditorContentViewController()

                editorViewController.zoom = Double(tileImageScrollView.zoomScale)
                editorViewController.positionX = Double(tileImageScrollView.contentOffset.x/tileImageScrollView.zoomScale + tileImageScrollView.bounds.size.width/tileImageScrollView.zoomScale/2)
                editorViewController.positionY = Double(tileImageScrollView.contentOffset.y/tileImageScrollView.zoomScale + tileImageScrollView.bounds.size.height/tileImageScrollView.zoomScale/2)

                self.show(editorViewController, sender: nil)
            }
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
            isSelected = false
            for marker in markerArray where marker.markIndex == markerIndex {
                let index = markerArray.index(of: marker)
                markerArray.remove(at: index!)
            }
            backBtn()
        }
    }

    // back button 구현
    @objc func backBtn() {
        isEditor = false
        isSelected = false
        tileImageScrollView.layer.borderWidth = 0
        centerPoint.isHidden = true

        self.navigationItem.rightBarButtonItem?.title = "Editor"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black

        markerDataSource?.reset()

        for marker in markerArray {
            marker.isSelected = false
            marker.isHidden = false
        }
    }

    func setupMarkerControl() {
        // editor에서 marker 추가
        NotificationCenter.default.addObserver(self, selector: #selector(addMarker), name: NSNotification.Name(rawValue: "makeMarker"), object: nil)

        // marker 선택시 hidden 이벤트
        NotificationCenter.default.addObserver(self, selector: #selector(showMarker), name: NSNotification.Name(rawValue: "showMarker"), object: nil)

        // marker index 지정
        UserDefaults.standard.set(0, forKey: "integerKeyName")
    }

    @objc func addMarker(_ notification: NSNotification) {
        let marker = MarkerView()
        if let x = notification.userInfo?["xFloat"] as? Double,
            let y = notification.userInfo?["yFloat"] as? Double,
            let zoom =  notification.userInfo?["zoomScale"] as? Double,
            let isAudioContent = notification.userInfo?["isAudioContent"] as? Bool,
            let isVideoContent = notification.userInfo?["isVideoContent"] as? Bool,
            let isTextContent = notification.userInfo?["isText"] as? Bool,
            let videoURL = notification.userInfo?["videoURL"] as? URL,
            let audioURL = notification.userInfo?["audioURL"] as? URL,
            let markerTitle = notification.userInfo?["title"] as? String,
            let link = notification.userInfo?["link"] as? String,
            let text = notification.userInfo?["text"] as? String {

            let contentDict:[String: Bool] = ["isTitleContent": true, "isAudioContent":isAudioContent,
                                              "isVideoContent": isVideoContent, "isTextContent": isTextContent]

            marker.set(dataSource: markerDataSource, origin: CGPoint(x: x, y: y), zoomScale: CGFloat(zoom), contentDict: contentDict)

            marker.setAudioContent(audioUrl: audioURL)
            marker.setVideoContent(videoUrl: videoURL)
            marker.setTitle(title: markerTitle)
            marker.setText(title: "", link: link, content: text)
        }
        marker.setMarkerImage(markerImage: #imageLiteral(resourceName: "page"))
        markerArray.append(marker)
        markerDataSource.framSet(markerView: marker)
        markerDataSource.reset()
    }

    @objc func showMarker(_ notification: NSNotification) {
        self.navigationItem.rightBarButtonItem?.title = "Delete Marker"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        isSelected = true

        if let num = notification.userInfo?["markIndex"] as? Int {
            markerIndex = num
        }

        for marker in markerArray {
            marker.isHidden = true
        }
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
        markerArray.forEach { marker in
            markerDataSource?.framSet(markerView: marker)
        }
    }
}
