//
//  GRCoreDataManager.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManager {
    func replaceItems(_ items: [GRItemModel], completion: @escaping(Error?) -> Void)
    func getItems(completion: @escaping(Result<[GRItem]?, Error>) -> Void)
}

class GRCoreDataManager: CoreDataManager {
    static let shared = GRCoreDataManager()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "granular")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    @discardableResult
    func saveContext() -> Error? {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                return error
            }
        }
        return nil
    }
    
    func replaceItems(_ items: [GRItemModel], completion: @escaping(Error?) -> Void) {
        DispatchQueue.main.async {
            if let error = self.clearItems() {
                completion(error)
                return
            }
            completion(self.addItems(items))
        }
    }
    
    func clearItems() -> Error? {
        let context = self.mainContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GRItem")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            return nil
        } catch {
            return error
        }
    }
    
    func addItems(_ items: [GRItemModel]) -> Error? {
        let context = self.mainContext
        let cdItems = items.compactMap({ GRItem.makeObject(from: $0, context: context) })
        cdItems.enumerated().forEach {$0.element.index = Int64($0.offset)}
        return self.saveContext()
    }
    
    func getItems(completion: @escaping(Result<[GRItem]?, Error>) -> Void) {
        DispatchQueue.main.async {
            let context = self.mainContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GRItem")
            request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                completion(.success(result as? [GRItem]))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
