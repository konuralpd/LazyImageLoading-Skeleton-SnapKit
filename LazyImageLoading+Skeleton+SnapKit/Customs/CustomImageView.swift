//
//  CustomImageView.swift
//  LazyImageLoading+Skeleton+SnapKit
//
//  Created by Mac on 17.04.2023.
//

import UIKit

class CustomImageView: UIImageView {
    
    var task: URLSessionDataTask!
    var imageCache = NSCache<AnyObject,AnyObject>()

    func loadImage(with url: URL) {
        image = nil
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let newImage = UIImage(data: data) else {
                print("Error occured when downloading Image.")
                return
            }
            self.imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }

}
