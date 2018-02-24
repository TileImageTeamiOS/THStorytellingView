//
//  EditorScrollView.swift
//  ScrollViewContent
//
//  Created by mac on 2018. 1. 9..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import MediaPlayer

class EditorScrollView: UIScrollView {
    var titleLabel = UILabel()
    var titleText = UITextField()
    var audioLabel = UILabel()
    var audioURLText = UITextField()
    var videoLabel = UILabel()
    var videoURLText = UITextField()
    var textTitleLabel = UILabel()
    var textTitleText = UITextField()
    var linkLabel = UILabel()
    var linkText = UITextField()
    var textLabel = UILabel()
    var detailText = UITextView()

    func set() {
        titleLabel.text = "Title"
        audioLabel.text = "Audio (URL)"
        videoLabel.text = "Video (URL)"
        textTitleLabel.text = "Text Title"
        linkLabel.text = "Link"
        textLabel.text = "Text"
        titleLabel.frame = CGRect(x: 30, y: 30, width: self.frame.width/2, height: 35)
        titleText.frame = CGRect(x: 30, y: 80, width: self.frame.width - 60, height: 35)
        titleText.borderStyle = .line
        audioLabel.frame = CGRect(x: 30, y: 130, width: self.frame.width/2, height: 35)
        audioURLText.frame = CGRect(x: 30, y: 180, width: self.frame.width - 60, height: 35)
        audioURLText.borderStyle = .line
        videoLabel.frame = CGRect(x: 30, y: 230, width: self.frame.width/2, height: 35)
        videoURLText.frame = CGRect(x: 30, y: 280, width: self.frame.width - 60, height: 35)
        videoURLText.borderStyle = .line
        textTitleLabel.frame = CGRect(x: 30, y: 330, width: self.frame.width/2, height: 35)
        textTitleText.frame = CGRect(x: 30, y: 380, width: self.frame.width - 60, height: 35)
        textTitleText.borderStyle = .line
        linkLabel.frame = CGRect(x: 30, y: 430, width: self.frame.width/2, height: 35)
        linkText.frame = CGRect(x: 30, y: 480, width: self.frame.width - 60, height: 35)
        linkText.borderStyle = .line
        textLabel.frame = CGRect(x: 30, y: 530, width: self.frame.width/2, height: 35)
        detailText.frame = CGRect(x: 30, y: 580, width: self.frame.width - 60, height: 500)
        detailText.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        self.addSubview(titleLabel)
        self.addSubview(titleText)
        self.addSubview(audioLabel)
        self.addSubview(audioURLText)
        self.addSubview(videoLabel)
        self.addSubview(videoURLText)
        self.addSubview(textTitleLabel)
        self.addSubview(textTitleText)
        self.addSubview(linkLabel)
        self.addSubview(linkText)
        self.addSubview(textLabel)
        self.addSubview(detailText)
    }
}
