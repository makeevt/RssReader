//
//  ManagedModel.swift
//  RssReader
//
//  Created by 1 on 05/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import CoreData

public protocol ManagedModel: AnyObject, NSFetchRequestResult {
    static var entityName: String { get }
}

extension ManagedModel where Self: NSManagedObject {
    
    public typealias ConfigureObject = (Self) -> ()

    public static func insertToContext(_ context: NSManagedObjectContext, configure: ConfigureObject?) -> Self {
        let newObject: Self = context.insertObject()
        if let configure = configure {
            configure(newObject)
        }
        return newObject
    }
    
}
