//
//  ImageStore.swift
//  Homepwner
//
//  Created by Sangho Oh on 25/03/2019.
//  Copyright © 2019 Oh Sangho. All rights reserved.
//

import UIKit

class ImageStore {
    
    let cache = NSCache<AnyObject, AnyObject>()
    
    // key를 이용한 이미지 URL setting...
    func imageURLForKey(key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as AnyObject)
        
        let imageURL = imageURLForKey(key: key)
        
        if let data = image.pngData() {
            // 에러 예외 처리
            do {
                try data.write(to: imageURL, options: .atomicWrite)
            } catch {
                print("Error writing the image to disk: \(error)")
            }
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as AnyObject) as? UIImage {
            return existingImage
        }
        
        let imageURL = imageURLForKey(key: key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as AnyObject)
        return imageFromDisk
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObject(forKey: key as AnyObject)
        
        let imageURL = imageURLForKey(key: key)
        // 에러 예외 처리
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
        
    }
}
