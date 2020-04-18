//
//  LocalImageViewController.swift
//  ImageLoader
//
//  Created by Jin Lee on 15/4/20.
//  Copyright © 2020 Jin Lee. All rights reserved.
//

import UIKit

class LocalImageViewController: UITableViewController {

    let photos = ["baby", "cat", "dog", "mum", "puffin", "rushmore", "sky"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Local Images"
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell

        let imageName = photos[indexPath.row]
        cell.aspectRatioImageView.image = UIImage(named: imageName)
        
        let size = cell.aspectRatioImageView.intrinsicContentSize
        cell.sizeLabel.text = "Image Size: \(round(size.width)) * \(round(size.height))"
        return cell
    }
}
