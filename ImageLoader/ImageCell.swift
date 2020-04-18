//
//  ImageCell.swift
//  ImageLoader
//
//  Created by Jin Lee on 15/4/20.
//  Copyright © 2020 Jin Lee. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var aspectRatioImageView: AspectRatioImageView!
    
    var feed: ImageFeed? { // for online image loading
        didSet {
            guard let feed = feed else { return }
            
            sizeLabel.text = "Image Size: \(feed.width) * \(feed.height)"
            
            /// adjust imageViewSize, for async image load this should be done before image downloading
            aspectRatioImageView.aspectConstraint = NSLayoutConstraint(item: aspectRatioImageView, attribute: .height, relatedBy: .equal, toItem: aspectRatioImageView, attribute: .width, multiplier: CGFloat(feed.height) / CGFloat(feed.width), constant: 0)
            
            /// 2. download image
            aspectRatioImageView.downloadImageFromURL(feed.imgPath) { [weak self] image in
                self?.aspectRatioImageView.image = image
            }
            
            setNeedsLayout()
        }
    }
    
    override func prepareForReuse() {
        sizeLabel.text = ""
        aspectRatioImageView.image = nil
        if feed != nil {
            feed = nil
        }
    }
}
