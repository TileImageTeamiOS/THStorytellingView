//
//  DataModel.swift
//  Demo
//
//  Created by mac on 2018. 2. 9..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import Foundation
import UIKit
import THMarkerView
import Firebase
import FirebaseDatabase

class DataModel {
    var markerArray = [THMarkerView]()
    var contentArray = [THContent]()
    var refer = Database.database().reference()
    var imgPath = "imghash1"
    func getImgs() {
        refer.observeSingleEvent(of: .value, with: { (snapshot) in
            if let getData = snapshot.value as? [String:Any] {
                print(getData.keys.sorted())
            }
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
                let markerKeyArray = markers.keys.sorted()
                let markerNum = markers.count
                for i in 0..<markerNum {
                    let marker = THMarkerView()
                    var content = Dictionary<String, Any>()
                    let markerInfo = markers[markerKeyArray[i]] as! [String:Any]
                    let position = markerInfo["position"] as! [String: Float]
                    let x = position["x"]
                    let y = position["y"]
                    let zoomScale = position["zoomScale"]
                    let contents = markerInfo["contents"] as! [String: String]
                    let video = contents["video"]
                    let audio = contents["audio"]
                    let title = contents["title"]
                    let text = contents["text"]
                    let link = contents["link"]
                    let textTitle = contents["textTitle"]
                    marker.frame.size =  CGSize(width: 20, height: 20)
                    marker.set(origin: CGPoint(x: CGFloat(x!), y: CGFloat(y!)), zoomScale: CGFloat(zoomScale!), scrollView: scrollView)
                    marker.setImage(markerImage: UIImage(named: "page.png")!)
                    marker.index = i
                    if title != "" {
                        content["titleoContent"] = title
                    }
                    if video != "" {
                        content["videoContent"] = URL(string: video!)
                    }
                    if audio != "" {
                        content["audioContent"] = URL(string: audio!)
                    }
                    if !(textTitle == "" && text == "" && link == "") {
                    }

                    self.markerArray.append(marker)
                    self.contentArray.append(THContent(contentInfo: content))
                }
            }
            completionHandler(true)
        })
    }
    
}
