//
//  ItemsViewModel.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import UIKit

protocol ItemsViewModelDelegate: class {
    func modelUpdated( _ model: ItemsViewModel)
}

class ItemsViewModel: NSObject {
    weak var delegate: ItemsViewModelDelegate?
    private var dataManager: DataManager
    private var items: [GRItemPresentable]?
    private var error: Error?
    let pageSize = 30
    var page = 0
    var moreAvailable = true
    var status = Status.loading
    
    var itemsCount: Int {
        return self.items?.count ?? 0
    }
    
    required init(with delegate: ItemsViewModelDelegate?, dataManager: DataManager = GRDataManager.shared) {
        self.dataManager = dataManager
        self.delegate = delegate
    }
    
    func load() {
        self.status = .loading
        self.page = 0
        self.items = nil
        GRDataManager.shared.getItems(startingIndex: self.page * self.pageSize, size: self.pageSize) { items, error in
            DispatchQueue.main.async { [weak self] in
                self?.update(with: items, error: error)
            }
        }
    }
    
    func loadNextPage() {
        self.status = .loading
        print("Load page \(self.page + 1)")
        GRDataManager.shared.getItems(startingIndex: (self.page + 1) * self.pageSize, size: self.pageSize) { items, error in
            DispatchQueue.main.async { [weak self] in
                self?.update(with: items, error: error)
            }
        }
    }
    
    func update(with items: [GRItemPresentable]?, error: Error?) {
        if let currentItems = self.items, let newItems = items {
            self.page = self.page + 1
            self.items = currentItems + newItems
        } else {
            self.items = items
        }
        self.moreAvailable = (items?.count ?? 0) == self.pageSize
        
        self.error = error
        if let error = error, !(error is GRServerError) {
            self.status = .error
        } else {
            self.status = .success
        }
        self.delegate?.modelUpdated(self)
    }
    
    func item(for indexPath: IndexPath) -> GRItemPresentable? {
        guard indexPath.row < self.itemsCount, let items = self.items else {
            return nil
        }
        return items[indexPath.row]
    }
    
    func alertMessage() -> String? {
        return (self.error as NSError?)?.localizedDescription
    }
    
    func infoMessage() -> String? {
        guard let _ =  self.error as? GRServerError else {
            return nil
        }
        return "Network call is failed. Items loaded from the locally stored copy"
    }
}

extension ItemsViewModel {
    enum Status {
        case success
        case loading
        case error
    }
}
