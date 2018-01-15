//
//  ImageProcessingVC.swift
//  Demo
//
//  Created by 홍창남 on 2018. 1. 14..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class ImageProcessingVC: UIViewController {

    @IBOutlet weak var imageShowButton: UIButton!
    @IBOutlet weak var imageSizeLabel: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // image cut info
    var imageName = "overWatch"
    var imageExtension = "jpg"
    let tiles: [CGSize] = [CGSize(width: 2048, height: 2048), CGSize(width: 1024, height: 1024),
                           CGSize(width: 512, height: 512), CGSize(width: 256, height: 256),
                           CGSize(width: 128, height: 128)]

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        var count = 0
        UIImage.saveTileOf(size: tiles, name: imageName, withExtension: imageExtension) { isSuccess in

            DispatchQueue.main.async {
                if isSuccess {
                    self.imageSizeLabel.text = "ImageSize \(self.tiles[count].width)\n Cutting has been finished."
                    count += 1
                    if count == self.tiles.count {
                        self.imageShowButton.isHidden = false
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                } else {
                    self.imageSizeLabel.text = "Image File Already Exists"
                    self.imageShowButton.isHidden = false
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowScrollView" {
            if let destination = segue.destination as? ViewController {
                destination.imageName = imageName
                destination.imageExtension = imageExtension
                destination.tiles = tiles
            }
        }
    }

    @IBAction func imageShowButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowScrollView", sender: nil)
    }

}
