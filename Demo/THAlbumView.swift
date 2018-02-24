//
//  THAlbumView.swift
//  THAlbumView
//
//  Created by mac on 2018. 2. 13..
//  Copyright © 2018년 th. All rights reserved.
//
import UIKit

public protocol THAlbumViewDelegate: AnyObject {
    func tapEvent(sender: AnyObject)
}
class THAlbumView: UIScrollView {
    weak var albumDelegate: THAlbumViewDelegate?
    private var firstRowY:CGFloat = 0
    private var secondRowY:CGFloat = 0
    private var index = 0
    func addImage(image: UIImage, imgKey: String) {
        let width = (self.frame.size.width - 10) / 2
        var tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTap(_:)))
        let height = image.size.height * (width / image.size.width)
        let imageView = UIImageView()
        imageView.image = image
        self.addSubview(imageView)
        imageView.frame.size.width = width
        imageView.frame.size.height = height
        if firstRowY <= secondRowY {
            imageView.frame.origin = CGPoint(x:CGFloat(0), y:firstRowY)
            firstRowY += height
            firstRowY += 10
        } else {
            imageView.frame.origin = CGPoint(x:width+10, y:secondRowY)
            secondRowY += height
            secondRowY += 10
        }
        imageView.accessibilityIdentifier = imgKey
        imageView.tag = index
        index += 1
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    func getHeight() -> CGFloat {
        if firstRowY >= secondRowY {
            return firstRowY + 10
        } else {
            return secondRowY + 10
        }
    }
}
extension THAlbumView: UIGestureRecognizerDelegate {
    @objc func photoTap(_ sender: AnyObject) {
        albumDelegate?.tapEvent(sender: sender)
    }
}
