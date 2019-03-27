//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Sangho Oh on 27/03/2019.
//  Copyright © 2019 Sangho Oh. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // cell 처음 생성될 때, indicating...
        updateWithImage(image: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // cell 재사용될 때, indicating...
        updateWithImage(image: nil)
    }
    
    // indicator method....
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}
