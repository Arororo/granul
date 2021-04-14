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
    static let downloadQueue = DispatchQueue.init(label: "imageDownloadQueue")
    static private var downloadTaskKey: Void?
    var downloadTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.downloadTaskKey) as? URLSessionDataTask
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIImageView.downloadTaskKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func loadImageUsingCache(withUrl urlString : String, completion: ((Bool) -> Void)? )  {
        self.downloadTask?.cancel()
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
        
        Self.downloadQueue.async { [weak self] in
            var request = URLRequest(url: url)
            request.httpMethod = APIMethod.get.rawValue
            self?.downloadTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    completion?(false)
                    return
                }
                var inImage: UIImage?
                if let data = data, let img = UIImage(data: data) {
                    UIImageView.imageCache.setObject(img, forKey: urlString as NSString)
                    inImage = img
                }
                DispatchQueue.main.async {
                    if let image = inImage {
                        self?.image = image
                    }
                    completion?(inImage != nil)
                }
            })
            self?.downloadTask?.resume()
        }
        
    }
}
