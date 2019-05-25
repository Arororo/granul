//
//  GRDataManager.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit

class GRDataManager: NSObject {
    static let shared = GRDataManager()
    
    func getItems(completion: @escaping(Result<[GRItemModel], Error>) -> Void) {
        GRNetworkManager.shared.getItems(completion: completion)
    }
}
