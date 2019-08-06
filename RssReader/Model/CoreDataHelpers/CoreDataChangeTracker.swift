import Foundation
import CoreData

public struct CoreDataRequest {
    public let predicate: NSPredicate
    public let sortDescriptors: [NSSortDescriptor]
    public let fetchLimit: Int?
    public init(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = [], fetchLimit: Int? = nil) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        self.fetchLimit = fetchLimit
    }
    public static var empty: CoreDataRequest {
        return CoreDataRequest(predicate: NSPredicate(value: false))
    }
}

public struct CoreDataChangeTransaction<U> {
    public var type: NSFetchedResultsChangeType
    
    public var oldIndexPath: IndexPath?
    public var newIndexPath: IndexPath?
    
    public var object: U
}

public struct CoreDataChangeTransactionBatch<U> {
    public var insertedTransactions = [CoreDataChangeTransaction<U>]()
    public var deletedTransactions = [CoreDataChangeTransaction<U>]()
    public var updatedTransactions = [CoreDataChangeTransaction<U>]()
    public var movedTransactions = [CoreDataChangeTransaction<U>]()
    
    public mutating func addTransaction(_ transaction: CoreDataChangeTransaction<U>) {
        switch transaction.type {
        case .insert:
            insertedTransactions.append(transaction)
        case .delete:
            deletedTransactions.append(transaction)
        case .move:
            movedTransactions.append(transaction)
        case .update:
            updatedTransactions.append(transaction)
        }
    }
    
    public var isEmpty: Bool {
        return insertedTransactions.isEmpty
    }
}

public class CoreDataChangeTracker<T: ManagedModel, U>: NSObject, NSFetchedResultsControllerDelegate {
    
    public typealias DidChangeHandler = (_ transaction: CoreDataChangeTransactionBatch<U>)->()
    
    // MARK:- Private properties
    
    private var controller: NSFetchedResultsController<T>!
    private var transactionBatch: CoreDataChangeTransactionBatch<U>?
    private var context: NSManagedObjectContext
    
    // MARK:- Lifecycle
    
    public init(cacheRequest: CoreDataRequest, context: NSManagedObjectContext) {
        transactionBatch = CoreDataChangeTransactionBatch<U>()
        self.context = context
        super.init()
        configure(with: cacheRequest)
    }
    
    // MARK:- Public properties
    
    /// required field. please specify handler for correct work with cache tracker
    public var didChangeHandler: DidChangeHandler!
    
    /// required field. please specify builder for correct work with cache tracker
    public var modelBuilder: ((T) -> (U))!
    
    public var modelsCount:Int {
        return (controller.fetchedObjects?.count ?? 0)
    }
    
    // MARK:- Public methods
    
    public func configure(with cacheRequest: CoreDataRequest) {
        let fetchRequest = T.defaultFetchRequest
        fetchRequest.predicate = cacheRequest.predicate
        fetchRequest.sortDescriptors = cacheRequest.sortDescriptors
        if let fetchLimit = cacheRequest.fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                managedObjectContext: context,
                                                sectionNameKeyPath: nil,
                                                cacheName: nil)
        controller.delegate = self
    }
    
    public func performFetch() {
        guard modelBuilder != nil else {
            fatalError("model builder must be specified")
        }
        guard didChangeHandler != nil else {
            fatalError("didChagneHandler must be specified")
        }
        
        do {
            try controller.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    public func fetchedModels() -> [U] {
        guard let objects = self.controller.fetchedObjects, !objects.isEmpty else {
            return []
        }
        return objects.map(modelBuilder)
    }
    
    public func modelForIndexPath(_ indexPath:IndexPath) -> U {
        let object = controller.object(at: indexPath)
        return modelBuilder(object)
    }
    
    public func objectForIndexPath(_ indexPath:IndexPath) -> T {
        return controller.object(at: indexPath)
    }
    
    public func indexPath(forObject: T?) -> IndexPath? {
        guard let object = forObject else {
            return nil
        }
        return controller.indexPath(forObject: object)
    }
    
    // MARK:- NSFetchedResultsControllerDelegate
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        transactionBatch = CoreDataChangeTransactionBatch<U>()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let plainObject = modelBuilder(anObject as! T)
        let transaction = CoreDataChangeTransaction(type: type, oldIndexPath: indexPath, newIndexPath: newIndexPath, object: plainObject)
        transactionBatch?.addTransaction(transaction)
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let batch = transactionBatch {
            didChangeHandler(batch)
        }
    }
}
