
import Foundation
import CoreData

public protocol ServiceLocator {
    var rssPersistentContainer: RSSPersistentContainer {get}
}

public class DefaultServiceLocator {
    public var rssPersistentContainerInternal: RSSPersistentContainer
    
    
    public init(rssPersistentContainer: RSSPersistentContainer) {
        self.rssPersistentContainerInternal = rssPersistentContainer
        
    }
}

extension DefaultServiceLocator: ServiceLocator {
    
    public var rssPersistentContainer: RSSPersistentContainer {
        return self.rssPersistentContainerInternal
    }
    
}
