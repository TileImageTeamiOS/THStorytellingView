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
import THContentMarkerView
import Kingfisher

class ViewController: UIViewController {
    
    //THTileImgeView set
    @IBOutlet weak var tileImageScrollView: THTiledImageScrollView!
    var tileImageDataSource: THTiledImageViewDataSource?
    var initialZoom:CGFloat = 0.0

    //THScrollView minimap set
    @IBOutlet weak var minimapView: THMinimapView!
    var minimapDataSource: THMinimapDataSource?

    //THMarker content set
    var contentMarkerController = THContentMarkerController(duration: 3.0, delay: 0.0, initialSpringVelocity: 0.66)
    var markerArray = [THMarker]()
    var contentSetArray = [THContentSet]()

    //THEditor set
    var centerPoint = UIView()
    var isEditor = false
    var isSelected = false
    var markerID = ""
    var selectedMarker = 0
    
    // image info
    var imageSize = CGSize()
    var tiles: [CGSize] = [CGSize(width: 1024, height: 1024), CGSize(width: 512, height: 512), CGSize(width: 256, height: 256)]
    
    // data parsing
    var dataModel = DataModel()
    
    // albumView
    let albumView = THAlbumView()
    var thumbnailImgs = [UIImage]()
    var selectedImage = UIView()
    var originPoint = CGPoint()
    var imageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        //set datamodel
        dataModel.setup()

        // set editor
        setupEditor()
        
        // content dict 설정
        contentMarkerController.dataSource = self
        contentMarkerController.delegate = self
        
        tileImageScrollView.alpha = 0
        navigationItem.rightBarButtonItem?.title = ""
        navigationItem.leftBarButtonItem?.title = ""
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        // set albumview
        setAlbumView()
        
        // set contentview
        setContentView()
    }
    override func viewWillAppear(_ animated: Bool) {
        showMarker()
        backToInitialZoom()
        self.tileImageScrollView.zoom(to: CGRect(x: 0, y: 0, width: (self.imageSize.width), height: (self.imageSize.height)), animated: false)
    }
    func setContentView() {
        // contentView set
        let videoKey = "videoContent"
        let thVideoContent = THVideoContentView()
        thVideoContent.frame = CGRect(x: self.view.center.x - 75, y: self.view.center.y + 80, width: 150, height: 100)
        thVideoContent.setContentView()
        contentSetArray.append(THContentSet(contentKey: videoKey, contentView: thVideoContent))
    
        let audioKey = "audioContent"
        let thAudioContent = THAudioContentView()
        thAudioContent.frame = CGRect(x: 0, y: 200, width: 80, height: 80)
        thAudioContent.setContentView()
        contentSetArray.append(THContentSet(contentKey: audioKey, contentView: thAudioContent))
    
        let titleKey = "titleContent"
        let thTitleContent = THTitleContentView()
        thTitleContent.frame.size = CGSize(width: 100, height: 50)
        thTitleContent.center = self.view.center
        thTitleContent.setView()
        contentSetArray.append(THContentSet(contentKey: titleKey, contentView: thTitleContent))
        
        let textKey = "textContent"
        let thTextContent = THTextContentView()
        thTextContent.frame = CGRect(x: 0, y: self.view.frame.height - self.view.frame.height*(1/5), width: self.view.frame.width, height: self.view.frame.height*(1/5))
        thTextContent.setContentView()
        contentSetArray.append(THContentSet(contentKey: textKey, contentView: thTextContent))
    }
    func getThumbnailImages() {
        dataModel.getSnapshot() {_ in
            self.dataModel.getImgs()
            for index in 0..<self.dataModel.thumbnailURL.count {
                ImageDownloader.default.downloadImage(with: self.dataModel.thumbnailURL[index], retrieveImageTask: nil,
                                                      options: [], progressBlock: nil) { (image,error,urlData, _) in
                                                        if error != nil {
                                                            return
                                                        } else {
                                                            guard let image = image, let _ = urlData else { return }
                                                            self.thumbnailImgs.append(image)
                                                            self.albumView.addImage(image: image, imgKey: self.dataModel.imgKey[index])
                                                            self.albumView.contentSize = CGSize(width: self.view.frame.width, height: self.albumView.getHeight())
                                                        }
                }
            }
        }
    }
    func setAlbumView() {
        albumView.frame = self.view.frame
        albumView.backgroundColor = UIColor.white
        self.view.addSubview(albumView)
        albumView.albumDelegate = self
        albumView.isScrollEnabled = true
        getThumbnailImages()
    }
    func setMarkerView() {
        contentMarkerController.markerRemove()
        contentMarkerController.markerViewImage = UIImage(named: "page.png")
        contentMarkerController.markerViewSize = CGSize(width: 25, height: 25)
        contentMarkerController.set(parentView: self.view, scrollView: self.tileImageScrollView)
        contentMarkerController.setMarkerFrame()
    }
    func showMarker() {
        dataModel.getMarkers(scrollView: tileImageScrollView) {_ in
            self.markerArray.removeAll()
            for i in 0..<self.dataModel.markerArray.count {
                self.markerArray.append(self.dataModel.markerArray[i])
            }
            self.setMarkerView()
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
    func setupTileImage(thumbnail: UIImage) {
        let tileImageBaseURL = dataModel.getTileImageBaseURL()
        if let size = dataModel.getImgSize() as? CGSize {
            imageSize = size
        } else {
            imageSize = thumbnail.size
        }
        tileImageDataSource = MyTileImageViewDataSource(tileImageBaseURL: tileImageBaseURL, imageSize: imageSize, tileSize: tiles)

        guard let dataSource = tileImageDataSource else { return }

        // 줌을 가장 많이 확대한 수준
        dataSource.maxTileLevel = dataModel.getMaxTileLevel()

        // 줌이 가장 확대가 안 된 수준
        dataSource.minTileLevel = dataModel.getMinTileLevel()

        dataSource.maxZoomLevel = CGFloat(dataModel.getMaxZoomLevel())

        // Local Image For Background
        dataSource.setBackgroundImage(image: thumbnail)

        dataSource.thumbnailImageName = dataModel.getTileImageName()
        dataSource.imageExtension = dataModel.getTileImageExtension()
        dataSource.delegate = self
        tileImageScrollView.set(dataSource: dataSource)
    }
    // editor button 구현
    @objc func editorBtn() {
        if isSelected == true {
            backToInitialZoom()
            markerArray.remove(at: selectedMarker)
            setMarkerView()
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
            editorViewController.dataModel = self.dataModel
            self.show(editorViewController, sender: nil)
        }
    }
    func backToAlbumView() {
        view.addSubview(albumView)
        for subview in minimapView.subviews {
            subview.removeFromSuperview()
        }
        imageSelected = false
        navigationItem.rightBarButtonItem?.title = ""
        navigationItem.leftBarButtonItem?.title = ""
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.isEnabled = false
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
            self.selectedImage.frame.origin = self.originPoint
            self.selectedImage.frame.size.width = (self.view.frame.size.width - 10)/2
            self.albumView.alpha = 1
            self.tileImageScrollView.alpha = 0
            for subView in self.albumView.subviews {
                subView.alpha = 1
            }
        }, completion: { _ in
            for subview in self.tileImageScrollView.subviews {
                subview.removeFromSuperview()
            }
        })
    }
    func backToInitialZoom() {
        if isEditor == true || isSelected == true {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.black
            self.navigationItem.rightBarButtonItem?.title = "Editor"
        }
        isEditor = false
        isSelected = false
        tileImageScrollView.layer.borderWidth = 0
        centerPoint.isHidden = true
        contentMarkerController.markerHidden(bool: false)
        contentMarkerController.contentDismiss()
    }
    func back() {
        if imageSelected && isEditor == false && isSelected == false && initialZoom == tileImageScrollView.zoomScale {
            backToAlbumView()
        } else {
            backToInitialZoom()
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
    func didZoom(scrollView: THTiledImageScrollView) {
        contentMarkerController.setMarkerFrame()
    }

    func didScroll(scrollView: THTiledImageScrollView) {
        minimapDataSource?.resizeMinimapView(minimapView: minimapView)
    }
}
extension ViewController: THContentMarkerControllerDataSource {
    func numberOfMarker(_ contentMarkerController: THContentMarkerController) -> Int {
        return markerArray.count
    }
    func setMarker(_ contentMarkerController: THContentMarkerController, markerIndex: Int) -> THMarker {
        return markerArray[markerIndex]
    }
    func numberOfContent(_ contentMarkerController: THContentMarkerController) -> Int {
        return contentSetArray.count
    }
    func setContentView(_ contentMarkerController: THContentMarkerController, contentSetIndex: Int) -> THContentSet {
        return contentSetArray[contentSetIndex]
    }
}

extension ViewController: THContentMarkerControllerDelegate {
    func markerTap(_ contentMarkerController: THContentMarkerController, marker: THMarkerView) {
        isSelected = true
        navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem?.title = "Delete Marker"
        contentMarkerController.markerHidden(bool: true)
        selectedMarker = marker.index
        markerID = marker.markerID
    }
}

extension ViewController: THAlbumViewDelegate {
    func tapEvent(sender: AnyObject) {
        let naviHeight = (self.navigationController?.navigationBar.frame.height)!
        let barHeight = UIApplication.shared.statusBarFrame.height
        originPoint = sender.view.frame.origin
        selectedImage = sender.view
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
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
            // set dataModel
            self.dataModel.imgPath = sender.view.accessibilityIdentifier!
            //
            self.setupTileImage(thumbnail: self.thumbnailImgs[sender.view.tag])
            // set minimap
            self.setupMinimap(thumbnailImage: self.thumbnailImgs[sender.view.tag])
            self.showMarker()
            self.initialZoom = self.tileImageScrollView.zoomScale
        })
    }
}
