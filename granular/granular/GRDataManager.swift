//
//  GRDataManager.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import Foundation

class GRDataManager {
    static let shared = GRDataManager()
    
    private var networkManager: NetworkManager
    private var coreDataManager: CoreDataManager
    
    required init(networkManager: NetworkManager = GRNetworkManager.shared,
                  coreDataManager: CoreDataManager = GRCoreDataManager.shared) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
    }
    
    func getItems(completion: @escaping(Result<[GRItem], Error>) -> Void) {
        GRNetworkManager.shared.getItems { (result) in
            switch result {
            case .success(let itemModels):
                if let error = self.coreDataManager.replaceItems(itemModels) {
                    completion(.failure(error))
                    return
                }
                self.coreDataManager.getItems { result in
                    switch result {
                    case .success(let items):
                        completion(.success(items ?? [GRItem]()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
