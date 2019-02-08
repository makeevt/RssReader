

import Foundation
import CoreData

extension Bundle {
    static private let managedObjectModelExtension = "momd"
    
    public func rss_managedObjectModel(name: String) -> NSManagedObjectModel {
        guard let url = url(forResource: name, withExtension: Bundle.managedObjectModelExtension) else {
            preconditionFailure("model not found for \(name) in bundle \(self)")
        }
        let model = NSManagedObjectModel(contentsOf: url)
        return model!
    }
}
