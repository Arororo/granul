//
//  GRItem+CoreDataProperties.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//
//

import Foundation
import CoreData

extension GRItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GRItem> {
        return NSFetchRequest<GRItem>(entityName: "GRItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var index: Int64

}
