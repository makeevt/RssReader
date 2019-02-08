

import Foundation
import CoreData
import UIKit

public typealias SetupCallback = (RSSPersistentContainer.SetupResult) -> Void

public class RSSPersistentContainer {
    var psc: NSPersistentStoreCoordinator
    
    public let mainContext: NSManagedObjectContext
    
    private let syncableContexts = Synchronized<NSHashTable<NSManagedObjectContext>>(value: NSHashTable<NSManagedObjectContext>.weakObjects())
    
    //MARK: - Init
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(psc: NSPersistentStoreCoordinator) {
        self.psc = psc
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = psc
        mainContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        syncableContexts.execute { (contexts) in
            contexts.add(mainContext)
        }
        
        addMemoryWarningObserver()
    }
    
}

extension RSSPersistentContainer {
    public enum SetupResult {
        case success(RSSPersistentContainer)
        case failure(Swift.Error)
    }
    
    public enum Error: Swift.Error {
        /// Case when an `NSPersistentStore` is not found for the supplied store URL
        case storeNotFound(at: URL)
        /// Case when an In-Memory store is not found
        case inMemoryStoreMissing
        /// Case when the store URL supplied to contruct function cannot be used
        case unableToCreateStore(at: URL)
    }
}

extension RSSPersistentContainer {
    public static func constructSQLiteStack(modelName: String,
                                            in bundle: Bundle = Bundle.main,
                                            at desiredStoreURL: URL? = nil,
                                            persistentStoreOptions: [AnyHashable : Any]? = NSPersistentStoreCoordinator.stockSQLiteStoreOptions,
                                            on callbackQueue: DispatchQueue? = nil,
                                            callback: @escaping SetupCallback) {
        
        let model = bundle.rss_managedObjectModel(name: modelName)
        let storeFileURL = desiredStoreURL ?? URL(string: "\(modelName).sqlite", relativeTo: URL.rss_documentsDirectiryURL)!
        self.constructSQLiteStack(model: model, at: storeFileURL, persistentStoreOptions: persistentStoreOptions, on: callbackQueue, callback: callback)
    }
    
    public static func constructSQLiteStack(model: NSManagedObjectModel,
                                            at storeURL: URL,
                                            persistentStoreOptions: [AnyHashable : Any]? = NSPersistentStoreCoordinator.stockSQLiteStoreOptions,
                                            on callbackQueue: DispatchQueue? = nil,
                                            callback: @escaping SetupCallback) {
        do {
            try FileManager.default.createDirectoryIfNecessary(storeURL)
        } catch {
            callback(.failure(Error.unableToCreateStore(at: storeURL)))
        }
        
        let backgroundQueue = DispatchQueue.global()
        let callbackQueue: DispatchQueue = callbackQueue ?? backgroundQueue
        NSPersistentStoreCoordinator.setupSQLiteBackedCoordinator(
            model,
            storeFileURL: storeURL,
            persistentStoreOptions: persistentStoreOptions) { coordinatorResult in
                switch coordinatorResult {
                case .success(let coordinator):
                    let stack = RSSPersistentContainer(psc: coordinator)
                    callbackQueue.async {
                        callback(.success(stack))
                    }
                case .failure(let error):
                    callbackQueue.async {
                        callback(.failure(error))
                    }
                }
        }
    }
}

extension RSSPersistentContainer {
    private func addMemoryWarningObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedMemoryWarning(notification:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    @objc func receivedMemoryWarning(notification: Notification){
        for syncableContext in self.syncableContexts.value.allObjects {
            syncableContext.perform {
                for object in syncableContext.registeredObjects where !object.isFault && !object.hasChanges {
                    syncableContext.refresh(object, mergeChanges: false)
                }
            }
        }
    }
}
