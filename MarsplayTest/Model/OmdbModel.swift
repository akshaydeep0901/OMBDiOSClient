//
//  OmdbModel.swift
//  MarsplayTest
//
//  Created by Akshay on 19/01/20.
//  Copyright © 2020 Akshay Deep Singh. All rights reserved.
//

import UIKit

class OmdbModel: NSObject {
    
    let title: String
    let id: String
    let year: String
    let poster: String
    let type: String
    
    var yearDisplayText: String {
        return year.calculateYearAgo()
    }
    
    init(json: [String: Any]) {
        self.id = String.init(dict: json, key: "imdbID")
        
        self.title = String.init(dict: json, key: "Title")
        self.year = String.init(dict: json, key: "Year")
        self.poster = String.init(dict: json, key: "Poster")
        self.type = String.init(dict: json, key: "Type")
    }
    
    class func parse(list: [[String: Any]]) -> [OmdbModel] {
        var omdbData: [OmdbModel] = []
        
        for each in list {
            omdbData.append(OmdbModel(json: each))
        }
        
        return omdbData
    }
}

extension String {
    init(dict: [String: Any], key: String) {
        if let str = dict[key] as? String {
            self = str
        } else if let str = dict[key] {
            self = "\(str)"
        } else {
            self = ""
        }
    }
    
    func calculateYearAgo() -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        let toYearValue = Int(self) ?? 0
        let result = String.init(describing: currentYear - toYearValue)
        
        return result + " year(s) ago"
    }
    
}
