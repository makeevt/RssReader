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

class CDRssSource: NSManagedObject {
    
    @NSManaged public var imageUrl: String?
    @NSManaged public var link: String?
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var numberOfUnread: Int32
    
}
