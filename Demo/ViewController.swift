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
import THMarkerView

class ViewController: UIViewController {
    //THTileImgeView set
    @IBOutlet weak var tileImageScrollView: THTiledImageScrollView!
    var tileImageDataSource: THTiledImageViewDataSource?

    //THScrollView minimap set
    @IBOutlet weak var minimapView: THMinimapView!
    var minimapDataSource: THMinimapDataSource?

    //THScrollView content set
    var contentArray: [THContent] = []
    var contentViewController = THContentViewController()
    var markerArray = [THMarkerView]()

    //THEditor set
    var centerPoint = UIView()
    var isEditor = false
    var isSelected = false
    var markerID = ""
    var selectedMarker = 0
    
    // image info
    var imageSize = CGSize()
    var thumbnailName = "overwatchthumbnail"
    var thumbnailExtension = "jpg"
    var imageName: String = ""
    var imageExtension: String = ""
    var tiles: [CGSize] = []
    
    // data parsing
    var dataModel = DataModel()
    
    // albumView
    let albumView = THAlbumView()
    var selectedImage = UIView()
    var originPoint = CGPoint()
    var imageSelected = false

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

        // set editor
        setupEditor()
        
        // content dict 설정
        contentViewController.dataSource = self
        contentViewController.set(parentView: self.view)
        
        setAlbumView()
        tileImageScrollView.alpha = 0
        navigationItem.rightBarButtonItem?.title = ""
        navigationItem.leftBarButtonItem?.title = ""
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        showMarker()
        back()
        self.tileImageScrollView.zoom(to: CGRect(x: 0, y: 0, width: (self.imageSize.width), height: (self.imageSize.height)), animated: false)
    }
    func setAlbumView() {
        albumView.frame = self.view.frame
        var index = 0
        var imageArray = [UIImage]()
        while index < 14{
            let imageName = NSString(format: "%d.jpg", index)
            let image = UIImage(named: imageName as String)
            imageArray.append(image!)
            index += 1
        }
        albumView.albumDelegate = self
        albumView.addImageViews(imageArray: imageArray)
        self.view.addSubview(albumView)
        albumView.contentSize = CGSize(width: self.view.frame.width, height: albumView.getHeight())
        albumView.isScrollEnabled = true
    }
    func showMarker() {
        dataModel.getMarkers(scrollView: tileImageScrollView) {_ in
            for marker in self.markerArray {
                marker.removeFromSuperview()
            }
            self.markerArray.removeAll()
            self.contentArray.removeAll()
            for i in 0..<self.dataModel.markerArray.count {
                self.dataModel.markerArray[i].delegate = self
                self.markerArray.append(self.dataModel.markerArray[i])
                self.contentArray.append(self.dataModel.contentArray[i])
            }
            for marker in self.markerArray {
                marker.framSet()
            }
        }
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
        if isSelected == true {
            back()
            markerArray[selectedMarker].isHidden = true
            markerArray.remove(at: selectedMarker)
            UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
                self.tileImageScrollView.zoom(to: CGRect(x: 0, y: 0, width: (self.imageSize.width), height: (self.imageSize.height)), animated: false)
            })
            dataModel.deleteMarker(markerID: markerID)
        } else if isEditor == false {
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
            editorViewController.zoom = tileImageScrollView.zoomScale
            editorViewController.positionX = tileImageScrollView.contentOffset.x/tileImageScrollView.zoomScale + tileImageScrollView.bounds.size.width/tileImageScrollView.zoomScale/2
            editorViewController.positionY = tileImageScrollView.contentOffset.y/tileImageScrollView.zoomScale + tileImageScrollView.bounds.size.height/tileImageScrollView.zoomScale/2
            self.show(editorViewController, sender: nil)
            
        }
    }

    func back() {
        if imageSelected && isEditor == false && isSelected == false {
            self.view.addSubview(albumView)
            self.imageSelected = false
            self.navigationItem.rightBarButtonItem?.title = ""
            self.navigationItem.leftBarButtonItem?.title = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
                self.selectedImage.frame.origin = self.originPoint
                self.selectedImage.frame.size.width = (self.view.frame.size.width - 10)/2
                self.albumView.alpha = 1
                self.tileImageScrollView.alpha = 0
                for subView in self.albumView.subviews {
                    subView.alpha = 1
                }
            })
        } else {
            if isEditor == true || isSelected == true {
                navigationItem.rightBarButtonItem?.tintColor = UIColor.black
                self.navigationItem.rightBarButtonItem?.title = "Editor"
            }
            isEditor = false
            isSelected = false
            tileImageScrollView.layer.borderWidth = 0
            centerPoint.isHidden = true
            for marker in markerArray {
                marker.isHidden = false
            }
            contentViewController.dismiss()
        }
    }
    // back button 구현
    @objc func backBtn() {
        back()
        UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
            self.tileImageScrollView.zoom(to: CGRect(x: 0, y: 0, width: (self.imageSize.width), height: (self.imageSize.height)), animated: false)
        })
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
        for marker in markerArray {
            marker.framSet()
        }
    }
}
extension ViewController: THMarkerViewDelegate {
    func tapEvent(marker: THMarkerView) {
        for marker in markerArray {
            marker.isHidden = true
        }
        markerID = marker.markerID
        selectedMarker = marker.index
        contentViewController.show(content: contentArray[marker.index])
        isSelected = true
        self.navigationItem.rightBarButtonItem?.title = "Delete Marker"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
    }
}
extension ViewController: THContentViewControllerDataSource {
    func setContentView(_ contentController: THContentViewController) -> [THContentView] {
        let videoContentView = THVideoContentView()
        videoContentView.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
        videoContentView.setContentView()
        return [videoContentView]
    }
    func setContentKey(_ contentController: THContentViewController) -> [String] {
        return ["videoContent"]
    }
}
extension ViewController: THAlbumViewDelegate {
    func tapEvent(sender: AnyObject) {
        let naviHeight = (self.navigationController?.navigationBar.frame.height)!
        let barHeight = UIApplication.shared.statusBarFrame.height
        originPoint = sender.view.frame.origin
        selectedImage = sender.view
        UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
            self.albumView.bringSubview(toFront: sender.view)
            self.selectedImage.frame.size.width = self.view.frame.width
            self.selectedImage.frame.origin.x = 0
            self.selectedImage.frame.origin.y = (self.view.frame.height - sender.view.frame.height/2)/2 + self.albumView.contentOffset.y
            for subView in self.albumView.subviews {
                if subView != sender.view {
                    subView.alpha = 0
                }
            }
            self.tileImageScrollView.alpha = 1
        }, completion: { _ in
            self.imageSelected = true
            self.albumView.removeFromSuperview()
            self.albumView.alpha = 0
            self.navigationItem.rightBarButtonItem?.title = "Editor"
            self.navigationItem.leftBarButtonItem?.title = "Back"
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        })
    }
}

