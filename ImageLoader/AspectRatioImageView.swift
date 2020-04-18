//
//  AspectRatioImageView.swift
//  ImageLoader
//
//  Created by Jin Lee on 15/4/20.
//  Copyright © 2020 Jin Lee. All rights reserved.
//

import UIKit

class AspectRatioImageView: UIImageView {

    override var image: UIImage? {
        didSet {
            guard let imageSize = image?.size else { return }
            
            aspectConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: imageSize.height / imageSize.width, constant: 0)
        }
    }

    var aspectConstraint: NSLayoutConstraint? {
        didSet {
            if let oldValue = oldValue {
                removeConstraint(oldValue)
            }
            
            if let aspectConstraint = aspectConstraint {
                aspectConstraint.priority = UILayoutPriority(999)
                addConstraint(aspectConstraint)
            }
        }
    }

}


extension UIImageView {
    func downloadImageFromURL(_ url: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(nil)
            return
        }

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    completionHandler(nil)
                    return
            }
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
        task.resume()
    }
}
