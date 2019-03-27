//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Sangho Oh on 27/03/2019.
//  Copyright © 2019 Sangho Oh. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var store: PhotoStore!
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImageForPhoto(photo: photo) { (result) in
            switch result {
            case let .Success(image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case let .Failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
    
}
