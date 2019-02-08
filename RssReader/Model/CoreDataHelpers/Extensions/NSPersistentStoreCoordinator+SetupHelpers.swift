

import Foundation
import CoreData

extension NSPersistentStoreCoordinator {
    public static var stockSQLiteStoreOptions: [AnyHashable: Any] {
        return [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true,
            NSSQLitePragmasOption: ["journal_mode": "WAL"]
        ]
    }
    
    public enum CoordinatorResult {
        /// A success case with associated `NSPersistentStoreCoordinator` instance
        case success(NSPersistentStoreCoordinator)
        /// A failure case with associated `ErrorType` instance
        case failure(Error)
    }
    
    public class func setupSQLiteBackedCoordinator(_ managedObjectModel: NSManagedObjectModel,
                                                   storeFileURL: URL,
                                                   persistentStoreOptions: [AnyHashable : Any]? = NSPersistentStoreCoordinator.stockSQLiteStoreOptions,
                                                   completion: @escaping (NSPersistentStoreCoordinator.CoordinatorResult) -> Void) {
        let backgroundQueue = DispatchQueue.global(qos: .background)
        backgroundQueue.async {
            do {
                let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: storeFileURL,
                                                   options: persistentStoreOptions)
                completion(.success(coordinator))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}
