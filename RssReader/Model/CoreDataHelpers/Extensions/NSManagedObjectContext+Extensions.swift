//
//  NSManagedObjectContext+Extensions.swift
//  RssReader
//
//  Created by 1 on 05/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    public func insertObject<A: NSManagedObject>() -> A where A: ManagedModel {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
    
    @discardableResult
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            print(error)
            rollback()
            print(error)
            return false
        }
    }
    
    public func performSaveOrRollback() {
        perform {
            _ = self.saveOrRollback()
        }
    }
    
    public func performChangesAndSaveOrRollBack(block: @escaping () -> ()) {
        performChangesAndSaveOrRollBack(block: block,
                                        completion: {(_)in})
    }
    
    public func performChangesAndSaveOrRollBack(block: @escaping () -> (), completion: @escaping (Bool) -> Void) {
        perform {
            block()
            let result: Bool
            if self.hasChanges {
                result = self.saveOrRollback()
            } else {result = true}
            completion(result)
        }
    }
    
}
