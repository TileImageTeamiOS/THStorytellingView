//
//  DataModel.swift
//  Demo
//
//  Created by mac on 2018. 2. 9..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import Foundation
import UIKit
import THContentMarkerView
import Firebase
import FirebaseDatabase
import Kingfisher

class DataModel {
    var markerArray = [THMarker]()
    var thumbnailURL = [URL]()
    var refer: DatabaseReference!
    var imgKey = [String]()
    var imgPath = "imghash1"
    var getData = [String:Any]()
    func setup() {
        refer = Database.database().reference()
    }
    func getSnapshot(completionHandler:@escaping (Bool) -> ()) {
        refer.observeSingleEvent(of: .value, with: { (snapshot) in
            if let getData = snapshot.value as? [String:Any] {
                self.getData = getData
            }
            completionHandler(true)
        })
    }
    func getImgs() {
        let imgs = getData.keys.sorted()
        for img in imgs {
            if let imgData = getData[img] as? [String:Any] {
                imgKey.append(img)
                if let thumbnail = imgData["thumbnail"] as? String {
                    let url = URL(string: thumbnail)
                    thumbnailURL.append(url!)
                }
            }
        }
    }
    func getTileImageBaseURL() -> URL {
        if let imgData = getData[imgPath] as? [String:Any] {
            if let tileImageBaseURL = imgData["img"] as? String {
                return URL(string: tileImageBaseURL)!
            } else {
                return URL(string: "http://127.0.0.1:5000/")!
            }
        } else {
            return URL(string: "http://127.0.0.1:5000/")!
        }
    }
    func getTileImageName() -> String {
        if let imgData = getData[imgPath] as? [String:Any] {
            if let tileImageName = imgData["imgName"] as? String {
                return tileImageName
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    func getTileImageExtension() -> String {
        if let imgData = getData[imgPath] as? [String:Any] {
            if let tileImageExtension = imgData["imgExtension"] as? String {
                return tileImageExtension
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    func getImgSize() -> CGSize? {
        if let imgData = getData[imgPath] as? [String:Any] {
            if let width = imgData["width"] as? Float, let height = imgData["height"] as? Float {
                return CGSize(width: CGFloat(width), height: CGFloat(height))
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    func getMaxTileLevel() -> Int {
        if let imgData = getData[imgPath] as? [String:Any] {
            if let maxTileLevel = imgData["maxTileLevel"] as? Int {
                return maxTileLevel
            } else {
                return 3
            }
        } else {
            return 3
        }
    }
    func getMinTileLevel() -> Int {
        if let imgData = getData[imgPath] as? [String:Any] {
            if let minTileLevel = imgData["minTileLevel"] as? Int {
                return minTileLevel
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    func getMaxZoomLevel() -> Float {
        if let imgData = getData[imgPath] as? [String:Any] {
            if let maxZoomLevel = imgData["maxTileLevel"] as? Float {
                return maxZoomLevel
            } else {
                return 8
            }
        } else {
            return 8
        }
    }
    func getMarkers(scrollView: UIScrollView){
        if let imgData = getData[imgPath] as? [String:Any] {
            if let markers = imgData["markers"] as? [String:Any] {
                self.markerArray.removeAll()
                let markerKeyArray = markers.keys.sorted()
                let markerNum = markers.count
                for i in 0..<markerNum {
                    let markerInfo = markers[markerKeyArray[i]] as! [String:Any]
                    let position = markerInfo["position"] as! [String: Float]
                    let x = position["x"]
                    let y = position["y"]
                    let zoomScale = position["zoomScale"]
                    var content = Dictionary<String, Any>()
                    if let contents = markerInfo["contents"] as? [String: String] {
                        let video = contents["video"]
                        let audio = contents["audio"]
                        let title = contents["title"]
                        let text = contents["text"]
                        let link = contents["link"]
                        let textTitle = contents["textTitle"]
                        if title != nil {
                            content["titleoContent"] = title
                        }
                        if video != nil {
                            content["videoContent"] = URL(string: video!)
                        }
                        if audio != nil {
                            content["audioContent"] = URL(string: audio!)
                        }
                        if !(textTitle == nil && text == nil && link == nil) {
                        }
                    }
                    let marker = THMarker(zoomScale: CGFloat(zoomScale!) , origin: CGPoint(x: CGFloat(x!), y: CGFloat(y!)), markerID: markerKeyArray[i], contentInfo: content)
                    self.markerArray.append(marker)
                }
            }
        }
    }
    func getMarkers(scrollView: UIScrollView, completionHandler:@escaping (Bool) -> ()) {
        refer.child(imgPath).child("markers").observeSingleEvent(of: .value, with: { (snapshot) in
            if let markers = snapshot.value as? [String:Any] {
                self.markerArray.removeAll()
                let markerKeyArray = markers.keys.sorted()
                let markerNum = markers.count
                for i in 0..<markerNum {
                    let markerInfo = markers[markerKeyArray[i]] as! [String:Any]
                    let position = markerInfo["position"] as! [String: Float]
                    let x = position["x"]
                    let y = position["y"]
                    let zoomScale = position["zoomScale"]
                    var content = Dictionary<String, Any>()
                    if let contents = markerInfo["contents"] as? [String: String] {
                        let video = contents["video"]
                        let audio = contents["audio"]
                        let title = contents["title"]
                        let text = contents["text"]
                        let link = contents["link"]
                        let textTitle = contents["textTitle"]
                        if title != nil {
                            content["titleoContent"] = title
                        }
                        if video != nil {
                            content["videoContent"] = URL(string: video!)
                        }
                        if audio != nil {
                            content["audioContent"] = URL(string: audio!)
                        }
                        if !(textTitle == nil && text == nil && link == nil) {
                        }
                    }
                    let marker = THMarker(zoomScale: CGFloat(zoomScale!) , origin: CGPoint(x: CGFloat(x!), y: CGFloat(y!)), markerID: markerKeyArray[i], contentInfo: content)
                    self.markerArray.append(marker)
                }
            }
            completionHandler(true)
        })
    }
    func addMarker(position: Dictionary<String, CGFloat>, contents: Dictionary<String, String>, completionHandler:@escaping (Bool) -> ()) {
        refer.child(imgPath).child("markers").observeSingleEvent(of: .value, with: { (snapshot) in
            let markerID = UUID().uuidString
            self.refer.child(self.imgPath).child("markers").child(markerID).child("position").setValue(position)
            self.refer.child(self.imgPath).child("markers").child(markerID).child("contents").setValue(contents)
            completionHandler(true)
        })
    }
    func deleteMarker(markerID: String) {
        refer.child(imgPath).child("markers").observeSingleEvent(of: .value, with: { (snapshot) in
            self.refer.child(self.imgPath).child("markers").child(markerID).removeValue()
        })
    }
}
