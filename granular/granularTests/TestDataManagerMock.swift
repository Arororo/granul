//
//  TestDataManager.swift
//  granularTests
//
//  Created by Dmitry Babenko on 2019-05-26.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit
import CoreData
@testable import granular

class TestDataManagerMock {
    var items: [GRItemPresentable]?
    var error: Error?
    var itemsCount = 100
    
    func setupSuccessState() {
        self.items = [1...self.itemsCount].map( {GRItemNetworkModel(name: "Name \($0)", url: "Images/\($0)")})
        self.error = nil
    }
    
    func setupFailedNetworkState() {
        self.items = [1...self.itemsCount].map( {GRItemNetworkModel(name: "Name \($0)", url: "Images/\($0)")})
        self.error = GRServerError(message: "Test network failier", code: nil)
    }
    
    func setupFailedState() {
        self.items = [1...self.itemsCount].map( {GRItemNetworkModel(name: "Name \($0)", url: "Images/\($0)")})
        self.error = GRServerError(message: "Test network failier", code: nil)
    }
}

extension TestDataManagerMock: DataManager {
    func getItems(completion: @escaping ([GRItemPresentable]?, Error?) -> Void) {
        completion(nil, self.error)
    }
}
