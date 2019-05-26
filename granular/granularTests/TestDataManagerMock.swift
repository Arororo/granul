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
    var items: [GRItemNetworkModel]?
    var error: Error?
    
    func setupSuccessState() {
        self.items = [1...100].map( {GRItemNetworkModel(name: "Name \($0)", url: "Images/\($0)")})
        self.error = nil
    }
}

extension TestDataManagerMock: DataManager {
    func getItems(completion: @escaping ([GRItem]?, Error?) -> Void) {
        completion(nil, self.error)
    }
}
