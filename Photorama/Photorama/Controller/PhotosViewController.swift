//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Sangho Oh on 27/03/2019.
//  Copyright © 2019 Sangho Oh. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 추후 다양한 서비스의 데이터를 컬렉션뷰에 이용하기 위해 datasource 추상화...
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        store.fetchRecentPhotos { (photosResult) in
            
            DispatchQueue.main.async {
                switch photosResult {
                case let .Success(photos):
                    print("Successfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                case let .Filure(error):
                    print("Error fetching recent photos: \(error)")
                    self.photoDataSource.photos.removeAll()
                }
                self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        }
    }
    
}

extension PhotosViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        store.fetchImageForPhoto(photo: photo) { (result) in
            DispatchQueue.main.async {
                
                // 사진의 indexPath는 요청의 시작일 때와 끝일 때 다를 수 있음...
                // 따라서 가장 최근의 indexPath를 확인...
                let photoIndex = self.photoDataSource.photos.firstIndex {$0 === photo}!
                let photoindexPath = IndexPath(row: photoIndex, section: 0)
                
                if let cell = self.collectionView.cellForItem(at: photoindexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(image: photo.image)
                }
            }
        }
    }
}
