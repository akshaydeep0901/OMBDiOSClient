//
//  ImageDownloader.swift
//  MarsplayTest
//
//  Created by Akshay on 19/01/20.
//  Copyright © 2020 Akshay Deep Singh. All rights reserved.
//

import UIKit

class ImageDownloader: NSObject {
    
    typealias ImageDownloaderCompletion = ((_ photo: OmdbModel, _ image: UIImage?, _ error: Error?) -> Void)
    static var imageMap: [String: UIImage] = [:]
    static var inprogresssList: [String: URLSessionDataTask] = [:]
    
    
    class func downloadImage(photo: OmdbModel, completion: @escaping ImageDownloaderCompletion) {
        let request = photo.poster
        
        if let existingImage = imageMap[request] {
            completion(photo, existingImage, nil)
            return
        }
        
        
        guard let requestURL = URL(string: request) else {
            completion(photo, nil, nil)
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            guard let imageData = data else {
                DispatchQueue.main.async {
                    completion(photo, nil, error)
                }
                return
            }
            
            let image = UIImage(data: imageData)
            
            if let parsedImage = image {
                imageMap[request] = parsedImage
            }
            DispatchQueue.main.async {
                completion(photo, image, nil)
            }
            
        }
        task.resume()
    }
}

