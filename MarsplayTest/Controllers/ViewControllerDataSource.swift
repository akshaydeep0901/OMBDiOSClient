//
//  ViewControllerDataSource.swift
//  MarsplayTest
//
//  Created by Akshay on 19/01/20.
//  Copyright © 2020 Akshay Deep Singh. All rights reserved.
//

import UIKit

class ViewControllerDataSource: NSObject {
    var photos: [OmdbModel] = []
    
    
    func updatenewImages(images: [OmdbModel]) {
        self.photos = images
    }
    
    func addNewImages(newImage: [OmdbModel]) {
        self.photos.append(contentsOf: newImage)
    }
}

extension ViewControllerDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayCollectionViewCell", for: indexPath) as? DisplayCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setData(photo: photos[indexPath.row])
        return cell
    }
}
