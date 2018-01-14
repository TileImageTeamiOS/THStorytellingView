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
    var audioNameText = UILabel()
    var audioSelectBtn = UIButton()
    var videoLabel = UILabel()
    var videoNameText = UILabel()
    var videoSelectBtn = UIButton()
    var linkLabel = UILabel()
    var linkText = UITextField()
    var textLabel = UILabel()
    var detailText = UITextView()
    
    func set() {
        titleLabel.text = "Title"
        audioLabel.text = "Audio"
        videoLabel.text = "Video"
        linkLabel.text = "Link"
        textLabel.text = "Text"
        titleLabel.frame = CGRect(x: 30, y: 30, width: self.frame.width/2, height: 35)
        titleText.frame = CGRect(x: 30, y: 80, width: self.frame.width - 60, height: 35)
        titleText.borderStyle = .line
        audioLabel.frame = CGRect(x: 30, y: 130, width: self.frame.width/2, height: 35)
        audioNameText.text = "파일을 선택해 주세요"
        audioNameText.frame = CGRect(x: 30, y: 180, width: self.frame.width/2, height: 35)
        audioSelectBtn.setTitle("file", for: .normal)
        audioSelectBtn.setTitleColor(UIColor.blue, for: .normal)
        audioSelectBtn.isEnabled = true
        audioSelectBtn.frame = CGRect(x: self.frame.width-130, y: 180, width: 100, height: 35)
        videoLabel.frame = CGRect(x: 30, y: 230, width: self.frame.width/2, height: 35)
        videoNameText.text = "파일을 선택해 주세요"
        videoSelectBtn.setTitle("file", for: .normal)
        videoSelectBtn.setTitleColor(UIColor.blue, for: .normal)
        videoSelectBtn.isEnabled = true
        videoSelectBtn.frame = CGRect(x: self.frame.width-130, y: 280, width: 100, height: 35)
        videoNameText.frame = CGRect(x: 30, y: 280, width: self.frame.width/2, height: 35)
        linkLabel.frame = CGRect(x: 30, y: 330, width: self.frame.width/2, height: 35)
        linkText.frame = CGRect(x: 30, y: 380, width: self.frame.width - 60, height: 35)
        linkText.borderStyle = .line
        textLabel.frame = CGRect(x: 30, y: 430, width: self.frame.width/2, height: 35)
        detailText.frame = CGRect(x: 30, y: 480, width: self.frame.width - 60, height: 500)
        detailText.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        self.addSubview(titleLabel)
        self.addSubview(titleText)
        self.addSubview(audioLabel)
        self.addSubview(audioNameText)
        self.addSubview(audioSelectBtn)
        self.addSubview(videoLabel)
        self.addSubview(videoNameText)
        self.addSubview(videoSelectBtn)
        self.addSubview(linkLabel)
        self.addSubview(linkText)
        self.addSubview(textLabel)
        self.addSubview(detailText)
    }
}
