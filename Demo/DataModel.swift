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
    var refer = Database.database().reference()
    var imgPath = "imghash1"
    func getImgs(completionHandler:@escaping (Bool) -> ()) {
        refer.observeSingleEvent(of: .value, with: { (snapshot) in
            if let getData = snapshot.value as? [String:Any] {
                let imgs = getData.keys.sorted()
                for img in imgs {
                    if let imgData = getData[img] as? [String:Any] {
                        let thumbnail = imgData["thumbnail"] as! String
                        let url = URL(string: thumbnail)
                        self.thumbnailURL.append(url!)
                    }
                }
            }
            completionHandler(true)
        })
    }
    func getThumbnail() {
        refer.child(imgPath).child("thumbnail").observeSingleEvent(of: .value, with: { (snapshot) in
            if let getData = snapshot.value as? String {
                print(getData)
            }
        })
    }
    func getTileImgs() {
        refer.child(imgPath).child("imgs").observeSingleEvent(of: .value, with: { (snapshot) in
            if let getData = snapshot.value as? [String:Any] {
            }
        })
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
