//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Sangho Oh on 27/03/2019.
//  Copyright © 2019 Sangho Oh. All rights reserved.
//

import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult {
    case Success([Photo])
    case Filure(Error)
}

enum FlickrError: Error {
    case InvalidJSONData
}

struct FlickrAPI {
    // base API URL..
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    // Method 구현...
    private static func flickrURL(method: Method, parameters: [String: String]?) -> URL {
        
        // URLComponents를 이용해 URL 구성.....
        var components = URLComponents(string: baseURLString)
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams  = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components?.queryItems = queryItems
        
        return components!.url!
    }
    
    // method url 겟...
    static func recentPhotosURL() -> URL {
        let url = flickrURL(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
        return url
    }
    
    static func photosFromJSONData(data: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            
            //
            guard let jsonDictionary = jsonObject as? [String: AnyObject],
                let photos = jsonDictionary["photos"] as? [String: AnyObject],
                let photosArray = photos["photo"] as? [[String: AnyObject]] else {
                    
                    // 일치하는 데이터 구조가가 없음...
                    return .Filure(FlickrError.InvalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(json: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.count == 0, photosArray.count > 0 {
                return .Filure(FlickrError.InvalidJSONData)
            }
            
            return .Success(finalPhotos)
        } catch let error {
            return .Filure(error)
        }
    }
    
    // json 데이터 파싱하여 사진 객체 생성하는 메소드...
    private static func photoFromJSONObject(json: [String: AnyObject]) -> Photo? {
        guard let photoID = json["id"] as? String,
        let title = json["title"] as? String,
        let dateString = json["datetaken"] as? String,
        let photoURLString = json["url_h"] as? String,
        let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else {
                // json의 데이터에 nil이 포함됨...
                return nil
        }
        // 사진 객체 생성..
        let photo = Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
        return photo
    }
    
}
