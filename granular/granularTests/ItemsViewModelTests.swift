//
//  granularTests.swift
//  granularTests
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import XCTest
@testable import granular

class ItemsViewModelTests: XCTestCase {

    func testSuccess() {
        let dataManager = TestDataManagerMock()
        dataManager.setupSuccessState()
        let viewModel = ItemsViewModel(with: nil, dataManager: dataManager)
        XCTAssert(viewModel.status == .loading)
        viewModel.load()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(viewModel.status == .success)
            XCTAssert(viewModel.itemsCount == viewModel.pageSize)
            XCTAssert(viewModel.page == 0)
            XCTAssertNil(viewModel.alertMessage())
            XCTAssertNil(viewModel.infoMessage())
        }
        viewModel.loadNextPage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(viewModel.status == .success)
            XCTAssert(viewModel.itemsCount == viewModel.pageSize * 2)
            XCTAssert(viewModel.page == 1)
            XCTAssertNil(viewModel.alertMessage())
            XCTAssertNil(viewModel.infoMessage())
        }
    }

    func testFailedNetwork() {
        let dataManager = TestDataManagerMock()
        dataManager.setupFailedNetworkState()
        let viewModel = ItemsViewModel(with: nil, dataManager: dataManager)
        viewModel.load()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(viewModel.status == .success)
            XCTAssert(viewModel.itemsCount == viewModel.pageSize)
            XCTAssertNil(viewModel.alertMessage())
            XCTAssertNotNil(viewModel.infoMessage())
        }
    }
    
    func testFailed() {
        let dataManager = TestDataManagerMock()
        dataManager.setupFailedState()
        let viewModel = ItemsViewModel(with: nil, dataManager: dataManager)
        viewModel.load()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(viewModel.status == .error)
            XCTAssert(viewModel.itemsCount == 0)
            XCTAssertNotNil(viewModel.alertMessage())
            XCTAssertNil(viewModel.infoMessage())
        }
    }
}
