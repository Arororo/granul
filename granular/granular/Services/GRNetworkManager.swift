//
//  GRNetworkManager.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import Foundation

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
        apiConnector.performRequest(method: APIMethod.get, path: itemsSubPath, queryParameters: params) { (result: Result<[GRItemNetworkModel], Error> ) in
            switch result {
            case .success(let itemModels):
                completion(Result.success(itemModels))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
