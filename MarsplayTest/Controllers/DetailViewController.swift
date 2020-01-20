//
//  DetailViewController.swift
//  MarsplayTest
//
//  Created by Akshay on 19/01/20.
//  Copyright © 2020 Akshay Deep Singh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var dataModel: OmdbModel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        
        // Do any additional setup after loading the view.
    }
    
    func setData() {
        self.imageView.image = nil
        self.yearLabel.text = "Released: " + dataModel.yearDisplayText
        self.typeLabel.text = "Type: " + dataModel.type
        self.titleLabel.text = "Title: " + dataModel.title
        
        ImageDownloader.downloadImage(photo: dataModel) {[weak self] (photo, image, error) in
            guard self?.dataModel == photo else {
                return
            }
            self?.imageView.image = image
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
