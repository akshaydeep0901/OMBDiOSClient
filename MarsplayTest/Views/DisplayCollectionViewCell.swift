//
//  DisplayCollectionViewCell.swift
//  MarsplayTest
//
//  Created by Akshay on 19/01/20.
//  Copyright © 2020 Akshay Deep Singh. All rights reserved.
//

import UIKit

class DisplayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var photo: OmdbModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setView()
    }
    
    func setView() {
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.cellImage.layer.cornerRadius = 5
    }
    
    func setData(photo: OmdbModel) {
        self.photo = photo
        self.cellImage.image = nil
        self.yearLabel.text = photo.yearDisplayText
        self.typeLabel.text = "Type: " + photo.type
        self.titleLabel.text = "Title: " + photo.title
        
        ImageDownloader.downloadImage(photo: photo) {[weak self] (photo, image, error) in
            guard self?.photo == photo else {
                return
            }
            self?.cellImage.image = image
        }
    }
}

