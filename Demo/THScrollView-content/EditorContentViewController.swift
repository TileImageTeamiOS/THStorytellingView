//
//  EditorContentViewController.swift
//  ScrollViewContent
//
//  Created by mac on 2018. 1. 10..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import MediaPlayer

class EditorContentViewController: UIViewController {
    var editorScrollView = EditorScrollView()
    var imagePicker: UIImagePickerController!
    var audioPicker: MPMediaPickerController!
    var videoPath = NSURL()
    var audioPath = NSURL()
    
    var x: Double = 0
    var y: Double = 0
    var zoom: Double = 1
    var isAudio = false
    var isVideo = false
    var focusOnText = false
    var keyboardHeight:CGFloat = 0
    var isText = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editorScrollView.frame = self.view.frame
        self.editorScrollView.contentSize = CGSize(width:self.view.frame.width,height:1000)
        self.editorScrollView.backgroundColor = UIColor.white
        self.view.addSubview(self.editorScrollView)
        editorScrollView.set()
        editorScrollView.isScrollEnabled = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(editorBack))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(editorDone))
        
        
        editorScrollView.audioSelectBtn.addTarget(self, action: #selector(self.chooseAudio), for: .touchUpInside)
        editorScrollView.videoSelectBtn.addTarget(self, action: #selector(self.chooseVideo), for: .touchUpInside)
        
        editorScrollView.detailText.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        
    }
    @objc func chooseAudio() {
        audioPicker = MPMediaPickerController(mediaTypes: MPMediaType.music)
        audioPicker.delegate = self
        audioPicker.allowsPickingMultipleItems = false
        present(audioPicker, animated: true, completion: nil)
    }
    
   @objc func chooseVideo() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.movie"]
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func editorBack() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func editorDone() {
        if (editorScrollView.linkText.text?.isEmpty)! && editorScrollView.detailText.text.isEmpty {
            isText = false
        }
        
        let markerDict:[String: Any] = ["x":x,"y":y,"zoomScale":zoom,"isAudioContent":isAudio,"isVideoContent":isVideo,"videoURL":videoPath, "audioURL":audioPath, "title":editorScrollView.titleText.text ?? "", "link":editorScrollView.linkText.text ?? "", "text":editorScrollView.detailText.text ?? "", "isText" : isText]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "makeMarker"), object: nil, userInfo: markerDict)

        
        self.navigationController?.popToRootViewController(animated: true)
    }
}
extension EditorContentViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 3.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
            self.view.frame.origin.y -= self.keyboardHeight
        })
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 3.0, initialSpringVelocity: 0.66, options: [.allowUserInteraction], animations: {
            self.view.frame.origin.y += self.keyboardHeight
        })
    }
}
extension EditorContentViewController: MPMediaPickerControllerDelegate {
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        audioPath = (mediaItemCollection.items.first?.assetURL as NSURL?)!
        
        self.editorScrollView.audioNameText.text = mediaItemCollection.items.first?.title
        audioPicker.dismiss(animated:true)
        audioPicker = nil
        isAudio = true
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.editorScrollView.audioNameText.text = "파일을 선택해 주세요"
        isAudio = false
        audioPicker.dismiss(animated:true)
        audioPicker = nil
    }
    
}


extension EditorContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        videoPath = info["UIImagePickerControllerMediaURL"] as! NSURL
        
        self.editorScrollView.videoNameText.text = videoPath.lastPathComponent
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
        isVideo = true
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.editorScrollView.videoNameText.text = "파일을 선택해 주세요"
        imagePicker.dismiss(animated: true, completion: nil)
        imagePicker = nil
        isVideo = false
    }
}

extension EditorContentViewController:  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
