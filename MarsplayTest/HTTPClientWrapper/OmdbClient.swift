//
//  OmdbClient.swift
//  MarsplayTest
//
//  Created by Akshay on 19/01/20.
//  Copyright © 2020 Akshay Deep Singh. All rights reserved.
//

import Foundation

class OmdbClient {
    
    typealias SearchImageCompletion = ((_ imagesResponse: [OmdbModel]?, _ error: Error?) -> Void)
    
    @discardableResult
    class func searchDataOnOMDB(searchString: String, page: Int, completion: @escaping SearchImageCompletion) -> URLSessionDataTask? {
        
        let newSearchString: String = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchString
        let request = Endpoint.omdbGet + "&s=\(newSearchString)&page=\(page)"
        
        guard let url = URL(string: request) else {
            completion(nil, nil)
            return nil
        }
        print("request: \(request)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print(error)
            guard let rawData = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            var json: [String: Any]?
            do {
                json = try JSONSerialization.jsonObject(with: rawData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
            } catch let e {
                DispatchQueue.main.async {
                    completion(nil, e)
                }
            }
            guard let parsedData = json, let photoList = parsedData["Search"] as? [[String: Any]] else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            let photosModel = OmdbModel.parse(list: photoList)
            DispatchQueue.main.async {
                completion(photosModel, nil)
            }
        }
        task.resume()
        return task
    }
}


struct Endpoint {
    static let omdbGet = "http://www.omdbapi.com/?apikey=\(AppKey.omdbKey)"
}

struct AppKey {
    static let omdbKey = "eeefc96f"
}


