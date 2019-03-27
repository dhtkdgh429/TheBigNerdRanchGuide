//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Sangho Oh on 27/03/2019.
//  Copyright © 2019 Sangho Oh. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var imageView : UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecentPhotos { (photosResult) in
            
            switch photosResult {
            case let .Success(photos):
                print("Successfully found \(photos.count) recent photos.")
                
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(photo: firstPhoto, completion: {
                        (imageResult) in
                        
                        switch imageResult {
                        case let .Success(image):
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                        case let .Failure(error):
                            print("Error downloading image: \(error)")
                        }
                    })
                }
                
            case let .Filure(error):
                print("Error fetching recent photos: \(error)")
            }
        }
    }
}
