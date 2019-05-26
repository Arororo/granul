//
//  granularTests.swift
//  granularTests
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import XCTest
@testable import granular

class granularTests: XCTestCase {

    func testSuccess() {
        let dataManager = TestDataManagerMock()
        dataManager.setupSuccessState()
        let viewModel = ItemsViewModel(with: nil, dataManager: dataManager)
        viewModel.load()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(viewModel.status == .success)
        }
    }

}
