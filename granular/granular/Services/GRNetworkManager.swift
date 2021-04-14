//
//  GRNetworkManager.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkManager {
    func getItems(completion: @escaping(Result<[GRItemNetworkModel], Error>) -> Void)
}
class GRNetworkManager: NetworkManager {
    
    static let shared = GRNetworkManager(with: GRAPIConnector(with: GRNetworkGlobalSettings.shared.apiConnectorConfiguration))
    private let itemsSubPath = "/list.json"
    private var apiConnector: APIConnector
    required init(with apiConnector: APIConnector) {
        self.apiConnector = apiConnector
    }
    
    func iconUrlString(for iconCode: String) -> String {
        return "\(apiConnector.baseURL)/\(iconCode)"
    }
    
    func getItems(completion: @escaping(Result<[GRItemNetworkModel], Error>) -> Void) {
        let params = [String : Any]()
        
//        let baseUrl = GRNetworkGlobalSettings.shared.apiConnectorConfiguration.baseURL
//        var items = [GRItemNetworkModel]()
//        for i in 1...1000 {
//            items.append(GRItemNetworkModel(name: String(i), url: "\(baseUrl)/\(i).jpg"))
//        }
////        items.forEach { generateAndSaveImage(for: $0.name ?? "nil", fileName: "\($0.name ?? "nil").jpg") }
//        let encoder = JSONEncoder()
//        if let data = try? encoder.encode(items) {
//            let json = String(data: data, encoding: .utf8)
//            print(json ?? "nil")
//        }
        
        apiConnector.performRequest(method: APIMethod.get, path: itemsSubPath, queryParameters: params) { (result: Result<[GRItemNetworkModel], Error> ) in
            switch result {
            case .success(let itemModels):
                completion(Result.success(itemModels))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
    
    private func generateAndSaveImage(for num: String, fileName: String) {
        guard let image = num.image(withAttributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 45),
        ],
        size: CGSize(width: 90, height: 90)) else { return }
//        ImageSaver().writeToPhotoAlbum(image: image)
        ImageSaver().saveJpg(image, fileName: fileName)
    }
}

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    func saveJpg(_ image: UIImage, fileName: String) {
        if let jpgData = image.jpegData(compressionQuality: 0.8),
            let path = documentDirectoryPath()?.appendingPathComponent(fileName) {
            do {
                try jpgData.write(to: path)
            } catch  {
                print(error)
            }
        }
    }
    
    private func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

extension String {
    
    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - attributes: to draw this string with. Default is `nil`.
    ///     - size: of the image to return.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        let strSize = (self as NSString).size(withAttributes: attributes)
        let size = size ?? strSize
        let origin = CGPoint(x: (size.width - strSize.width) / 2, y: (size.height - strSize.height) / 2)
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: CGRect(origin: origin, size: size),
                                    withAttributes: attributes)
        }
    }
    
}
