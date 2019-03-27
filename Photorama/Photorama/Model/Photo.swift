//
//  Photo.swift
//  Photorama
//
//  Created by Sangho Oh on 27/03/2019.
//  Copyright © 2019 Sangho Oh. All rights reserved.
//

import UIKit

class Photo {
    let title: String
    let photoID: String
    let remoteURL: URL
    let dateTaken: Date
    var image: UIImage?
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}


// MARK: - Equatable
extension Photo : Equatable {}
    func == (lhs: Photo, rhs: Photo) -> Bool {
        // 같은 photoID를 가지면 같은 사진임...
        return lhs.photoID == rhs.photoID
    }
