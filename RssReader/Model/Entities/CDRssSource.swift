//
//  CDRssSource.swift
//  RssReader
//
//  Created by 1 on 05/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation
import CoreData
import QueryKit

class CDRssSource: NSManagedObject, ManagedModel {
    
    static var entityName: String {
        return "CDRssSource"
    }
    
    @NSManaged var uuid: String
    @NSManaged var name: String
    @NSManaged var link: String
    @NSManaged var imageUrl: String?
    @NSManaged var note: String?
    @NSManaged var numberOfUnread: Int32
    @NSManaged var addingDate: Date
    
}

extension CDRssSource {
    
    static var uuid: Attribute<String> { return Attribute("uuid") }
    static var addingDate: Attribute<Date> { return Attribute("addingDate") }
    
    public static func predicateForUuid(uuid: String) -> NSPredicate {
        return predicate(CDRssSource.uuid == uuid)
    }
    
}

extension Attribute where AttributeType: CDRssSource {
    var uuidAttribute: Attribute<String> { return attribute(AttributeType.uuid) }
}
