//
//  EditorContentViewController.swift
//  ScrollViewContent
//
//  Created by mac on 2018. 1. 10..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import THContentMarkerView

class EditorContentViewController: UIViewController {
    var editorScrollView = EditorScrollView()
//    var imagePicker: UIImagePickerController!
//    var audioPicker: MPMediaPickerController!
//    var videoPath = ""
//    var audioPath = ""
    var positionX: CGFloat = 0
    var positionY: CGFloat = 0
    var zoom: CGFloat = 1
    var focusOnText = false
    var keyboardHeight:CGFloat = 0
    var dataModel = DataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editorScrollView.frame = self.view.frame
        self.editorScrollView.contentSize = CGSize(width:self.view.frame.width, height:1100)
        self.editorScrollView.backgroundColor = UIColor.white
        self.view.addSubview(self.editorScrollView)
        editorScrollView.set()
        editorScrollView.isScrollEnabled = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(editorBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(editorDone))
//        editorScrollView.audioSelectBtn.addTarget(self, action: #selector(self.chooseAudio), for: .touchUpInside)
//        editorScrollView.videoSelectBtn.addTarget(self, action: #selector(self.chooseVideo), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        editorScrollView.detailText.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        var editorTapGestureRecognizer = UITapGestureRecognizer()
        editorTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editorViewTap(_:)))
        editorTapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(editorTapGestureRecognizer)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
//    @objc func chooseAudio() {
//        audioPicker = MPMediaPickerController(mediaTypes: MPMediaType.music)
//        audioPicker.delegate = self
//        audioPicker.allowsPickingMultipleItems = false
//        present(audioPicker, animated: true, completion: nil)
//    }
//    @objc func chooseVideo() {
//        imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        imagePicker.allowsEditing = false
//        imagePicker.mediaTypes = ["public.movie"]
//        present(imagePicker, animated: true, completion: nil)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func alert(urlString: String, name: String) -> Bool {
        if let urlForCheck = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(urlForCheck).hashValue != 1 {
                let alert = UIAlertController(title: "Invaild input " + name + " URL", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                let parentVC = self.parent
                parentVC?.present(alert, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        } else {
            if urlString != "" {
                let alert = UIAlertController(title: "Invaild input " + name + " URL", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                let parentVC = self.parent
                parentVC?.present(alert, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        }
    }
    @objc func editorBack() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func editorDone() {
        let video = editorScrollView.videoURLText.text
        let audio = editorScrollView.audioURLText.text
        if alert(urlString: audio!, name: "audio") && alert(urlString: video!, name: "video") {
            var position = [String: Float]()
            var contents = [String: String]()
            contents["title"] = editorScrollView.titleText.text
            contents["video"] = video
            contents["audio"] = audio
            contents["textTitle"] = editorScrollView.textTitleText.text
            contents["text"] = editorScrollView.detailText.text
            contents["link"] = editorScrollView.linkText.text
            position["x"] = Float(positionX)
            position["y"] = Float(positionY)
            position["zoomScale"] = Float(zoom)
            let markerID = UUID().uuidString
            var contentInfo = [String: Any]()
            var textInfo = [String: String]()
            if editorScrollView.titleText.text != "" {
                contentInfo["titleContent"] = editorScrollView.titleText.text
            }
            if video != "" {
                contentInfo["videoContent"] = URL(string: video!)
            }
            if audio != "" {
                contentInfo["audioContent"] = URL(string: audio!)
            }
            textInfo["title"] = editorScrollView.textTitleText.text
            textInfo["link"] = editorScrollView.linkText.text
            textInfo["text"] = editorScrollView.detailText.text
            if editorScrollView.textTitleText.text != "" || editorScrollView.linkText.text != "" || editorScrollView.detailText.text != "" {
                contentInfo["textContent"] = textInfo
            }
            let marker = THMarker(zoomScale: zoom, origin: CGPoint(x: positionX, y: positionY), markerID: markerID, contentInfo: contentInfo)
            dataModel.markerArray.append(marker)
            dataModel.addMarker(position: position, contents: contents, markerID: markerID)
            if let rootVC = self.navigationController?.viewControllers[0] as? ViewController {
                rootVC.viewWillAppear()
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension EditorContentViewController: UITextViewDelegate {
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
extension EditorContentViewController:  UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension EditorContentViewController: UIGestureRecognizerDelegate {
    @objc func editorViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.editorScrollView.detailText.resignFirstResponder()
        self.editorScrollView.titleText.resignFirstResponder()
        self.editorScrollView.linkText.resignFirstResponder()
        self.editorScrollView.videoURLText.resignFirstResponder()
        self.editorScrollView.audioURLText.resignFirstResponder()
        self.editorScrollView.textTitleText.resignFirstResponder()
    }
}
//extension EditorContentViewController: MPMediaPickerControllerDelegate {
//    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
//        audioPath = (mediaItemCollection.items.first?.assetURL?.description)!
//        self.editorScrollView.audioNameText.text = mediaItemCollection.items.first?.title
//        audioPicker.dismiss(animated:true)
//        audioPicker = nil
//    }
//    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
//        self.editorScrollView.audioNameText.text = "파일을 선택해 주세요"
//        audioPicker.dismiss(animated:true)
//        audioPicker = nil
//    }
//}
//extension EditorContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let video = (info["UIImagePickerControllerMediaURL"] as! NSURL)
//        videoPath = video.description
//        self.editorScrollView.videoNameText.text = video.lastPathComponent
//        imagePicker.dismiss(animated: true, completion: nil)
//        imagePicker = nil
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.editorScrollView.videoNameText.text = "파일을 선택해 주세요"
//        imagePicker.dismiss(animated: true, completion: nil)
//        imagePicker = nil
//    }
//}
