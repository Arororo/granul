//
//  GRItem+Extension.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-26.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import Foundation
import CoreData

extension GRItem {
    static func makeObject(from modelItem: GRItemModel, context: NSManagedObjectContext) -> GRItem? {
        guard let entity = NSEntityDescription.entity(forEntityName: "GRItem", in: context) else {
            print("!!! Something went wrong! \(#function)")
            return nil
        }
        let newItem = NSManagedObject(entity: entity, insertInto: context) as? GRItem
        newItem?.name = modelItem.name
        newItem?.url = modelItem.url
        return newItem
    }
}
