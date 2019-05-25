//
//  UIImageView+Downloads.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit

extension UIImageView {
    
    static let imageCache: NSCache<NSString, UIImage> =  NSCache<NSString, UIImage>()
    
    func loadImageUsingCache(withUrl urlString : String, completion: ((Bool) -> Void)? )  {
        self.image = nil
        guard var urlComponents = URLComponents(string: urlString) else {
            completion?(false)
            return
        }
        urlComponents.scheme = GRNetworkGlobalSettings.shared.apiConnectorConfiguration.scheme
        guard let url = urlComponents.url else {
            completion?(false)
            return
        }
        // check cached image
        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            completion?(true)
            return
        }
        
        // if not, download image from url
        var request = URLRequest(url: url)
        request.httpMethod = APIMethod.get.rawValue
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                completion?(false)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    UIImageView.imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    completion?(true)
                } else {
                    completion?(false)
                }
            }
        }).resume()
    }
}
