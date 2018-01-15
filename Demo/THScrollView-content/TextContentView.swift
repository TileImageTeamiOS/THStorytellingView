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

    var upYFloat = CGFloat()
    var downYFloat = CGFloat()

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

    public func frameSet(upYFloat: CGFloat, downYFloat: CGFloat) {
        self.upYFloat = upYFloat
        self.downYFloat = downYFloat
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
                self.frame = CGRect(x: 0, y: (self.superview?.frame.height)! - self.upYFloat, width: (self.superview?.frame.width)!, height: self.upYFloat)
                self.contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                self.upImageView.transform = self.upImageView.transform.rotated(by: CGFloat(Double.pi))
            })
        } else {
            contentStatus = .hide

            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 0, y: (self.superview?.frame.height)! - self.downYFloat, width: (self.superview?.frame.width)!, height: self.downYFloat)
                self.contentScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                self.upImageView.transform = self.upImageView.transform.rotated(by: CGFloat(Double.pi))
            })
        }
    }

    @objc func linkLabelTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let url = URL(string: linkLable.text!)!

        if UIApplication.shared.canOpenURL(url).hashValue == 1 {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Invaild input URL", message: nil, preferredStyle: .alert)

            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)

            let parentVC = self.parentViewController
            parentVC?.present(alert, animated: true, completion: nil)
        }
    }
}
