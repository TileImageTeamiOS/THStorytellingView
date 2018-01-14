//
//  MyMinimapDataSource.swift
//  Demo
//
//  Created by Seong ho Hong on 2018. 1. 14..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import THScrollView_minimap

class MyMinimapDataSource: THMinimapDataSource {
    var originImageSize: CGSize?
    let scrollView: UIScrollView
    let thumbnailImage: UIImage
    var borderWidth: CGFloat
    var borderColor: UIColor
    var downSizeRatio: CGFloat

    init(scrollView: UIScrollView, thumbnailImage: UIImage, originImageSize: CGSize?) {
        self.scrollView = scrollView
        self.thumbnailImage = thumbnailImage
        self.originImageSize = originImageSize
        self.borderWidth = 0.0
        self.borderColor = UIColor()
        self.downSizeRatio = 0.0
    }

    func resizeMinimapView(minimapView: THMinimapView) {
        let rect = self.scrollViewVisibleSize.divideCGRectByDouble(ratio: self.downSizeRatio)
        minimapView.focusedBoxView?.frame = currentRect(rect: rect)
    }
}
