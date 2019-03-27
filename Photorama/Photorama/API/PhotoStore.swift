//
//  PhotoStore.swift
//  Photorama
//
//  Created by Sangho Oh on 27/03/2019.
//  Copyright © 2019 Sangho Oh. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage),
    Failure(Error)
}

enum PhotoError: Error {
    case ImageCreationError
}

class PhotoStore {
    
    // URLSession config init...
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // api.flickr.com에 최신 사진 목록을 요청하는 메소드...
//    func fetchRecentPhotos() {
    // 데이터 호출 클로져 처리...
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processRecentPhotosRequest(data: data, error: error)
            
            print("Photo response: \(response)")
            completion(result)
            
        }
        task.resume()
    }
    
    // json data에 대한 방어 코드...
    func processRecentPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .Filure(error!)
        }
        return FlickrAPI.photosFromJSONData(data: jsonData)
    }
    
    func fetchImageForPhoto(photo:Photo, completion: @escaping (ImageResult) -> Void) {
        
        // 이미지를 이미 받았다면, return...
        if let image = photo.image {
            completion(.Success(image))
            return
        }
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processImageRequest(data: data, error: error)
            // 아래 switch 코드 처리와 동일함....
            if case let .Success(image) = result {
                photo.image = image
            }
//            switch result {
//            case let .Success(image):
//                photo.image = image
//            case let .Failure(_):
//                break
//            }
            print("Image response: \(response)")
            completion(result)
        }
        task.resume()
    }
    
    // 웹에서 요청한 데이터를 이미지로 변환하는 메소드..
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            if data == nil {
                return .Failure(error!)
            } else {
                return .Failure(PhotoError.ImageCreationError)
            }
        }
        return .Success(image)
    }
}
