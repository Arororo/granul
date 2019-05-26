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
    private var items: [GRItem]?
    private var error: Error?
    
    var itemsCount: Int {
        return self.items?.count ?? 0
    }
    
    required init(with delegate: ItemsViewModelDelegate?) {
        self.delegate = delegate
    }
    
    func update(with result: Result<[GRItem], Error>) {
        self.items = nil
        self.error = nil
        switch result {
        case .success(let items):
            self.items = items
        case .failure(let error):
            self.error = error
        }
        self.delegate?.modelUpdated(self)
    }
    
    func item(for indexPath: IndexPath) -> GRItem? {
        guard indexPath.row < self.itemsCount, let items = self.items else {
            return nil
        }
        return items[indexPath.row]
    }
}
