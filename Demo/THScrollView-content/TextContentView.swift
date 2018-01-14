//
//  TextContentView.swift
//  ScrollViewMarker
//
//  Created by Seong ho Hong on 2018. 1. 7..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

enum ContentStatus: Int {
    case show = 1
    case hide
}

public class TextContentView: UIView {
    var textContentResizeView = UIView()
    var upImageView = UIImageView()
    private var resizeTapGestureRecognizer = UITapGestureRecognizer()
    private var linkLabelTapGestureRecognizer = UITapGestureRecognizer()
    
    var contentScrollView = UIScrollView()
    var titleLable = UILabel()
    var linkLable = UILabel()
    var textLabel = UILabel()
    
    var upY = CGFloat()
    var downY = CGFloat()
    
    var contentStatus: ContentStatus = .hide
    
    func setTextContent() {
        scrollSet()
        self.backgroundColor = UIColor.white
        
        textContentResizeView = UIView(frame: CGRect(x: self.frame.width - 30, y: 10, width: 25, height: 25))
        upImageView.frame.origin = .zero
        upImageView.frame.size = textContentResizeView.frame.size
        upImageView.image = UIImage(named: "up.png")
        upImageView.contentMode = .scaleAspectFit
        contentScrollView.addSubview(textContentResizeView)
        textContentResizeView.addSubview(upImageView)
        
        resizeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resizeViewTap(_:)))
        resizeTapGestureRecognizer.delegate = self
        textContentResizeView.addGestureRecognizer(resizeTapGestureRecognizer)
        
        linkLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(linkLabelTap(_:)))
        linkLabelTapGestureRecognizer.delegate = self
        linkLable.addGestureRecognizer(linkLabelTapGestureRecognizer)
    }
    
    private func scrollSet() {
        contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        contentScrollView.canCancelContentTouches = true
        self.addSubview(contentScrollView)
    }
    
    public func frameSet(upY: CGFloat, downY: CGFloat) {
        self.upY = upY
        self.downY = downY
    }
    
    public func labelSet(title: String?, link: String?, text: String?) {
        titleLable.frame.size = CGSize(width: self.frame.width, height: 10)
        titleLable.frame.origin = CGPoint(x: 10, y: 10)
        titleLable.text = title
        titleLable.numberOfLines = 2
        titleLable.textAlignment = .left
        titleLable.font = UIFont.boldSystemFont(ofSize: 15)
        titleLable.sizeToFit()
        
        linkLable.frame.size = CGSize(width: self.frame.width, height: 10)
        linkLable.frame.origin = CGPoint(x: 10, y: titleLable.frame.origin.y + titleLable.frame.height + 10)
        linkLable.text = link
        linkLable.numberOfLines = 2
        linkLable.textAlignment = .left
        linkLable.textColor = UIColor.blue
        linkLable.sizeToFit()
        linkLable.isUserInteractionEnabled = true
        
        textLabel.frame.size = CGSize(width: self.frame.width, height: 10)
        textLabel.frame.origin = CGPoint(x: 10, y: linkLable.frame.origin.y + linkLable.frame.height + 10)
        textLabel.text = text
        textLabel.numberOfLines = 100
        textLabel.textAlignment = .left
        textLabel.sizeToFit()
        
        contentScrollView.addSubview(titleLable)
        contentScrollView.addSubview(linkLable)
        contentScrollView.addSubview(textLabel)
        
        contentScrollView.sizeToFit()
        contentScrollView.contentSize = CGSize(width: self.frame.width, height: titleLable.frame.height + linkLable.frame.height + textLabel.frame.height + 10 + 10 + 10)
    }
}

extension TextContentView: UIGestureRecognizerDelegate {
    @objc func resizeViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if contentStatus == .hide {
            contentStatus = .show
            
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 0, y: (self.superview?.frame.height)! - self.upY, width: (self.superview?.frame.width)!, height: self.upY)
                self.contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                self.upImageView.transform = self.upImageView.transform.rotated(by: CGFloat(Double.pi))
            })
        } else {
            contentStatus = .hide
            
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 0, y: (self.superview?.frame.height)! - self.downY, width: (self.superview?.frame.width)!, height: self.downY)
                self.contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                self.upImageView.transform = self.upImageView.transform.rotated(by: CGFloat(Double.pi))
            })
        }
    }
    
    @objc func linkLabelTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let parentVC = self.parentViewController
        let webViewController = UIViewController()
        
        let webView = UIWebView(frame: webViewController.view.frame)
        webViewController.view.addSubview(webView)
        webView.loadRequest(URLRequest(url: URL(string: linkLable.text!)!))
        
        parentVC?.show(webViewController, sender: nil)
    }
}

