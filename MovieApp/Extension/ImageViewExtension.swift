//
//  ImageViewExtension.swift
//  MovieApp
//
//  Created by prema janoti on 3/2/18.
//  Copyright © 2018 prema. All rights reserved.
//

import UIKit
import Foundation

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    // MARK: - Download Image from URL
    
    func downloadImageFrom(link: String, contentMode: UIViewContentMode) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: link)) {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.image = UIImage(named: "placeholder")
                }
                return
            }
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: NSString(string: link))
                        self.image = downloadedImage
                    }
                }
            }
        }).resume()
    }
}
