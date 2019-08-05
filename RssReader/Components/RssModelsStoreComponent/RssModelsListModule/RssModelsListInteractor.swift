
import Foundation
import CoreData

protocol RssModelsListInteractorOutput: class {
    
}

protocol RssModelsListInteractor {
    var rssSourceModels: [RssSourceViewModel] { get }
}

class RssModelsListInteractorImpl: NSObject, RssModelsListInteractor {
    
    weak var output: RssModelsListInteractorOutput?
    
    private let serviceLocator: ServiceLocator
    private var fetchedResultsController: NSFetchedResultsController<CDRssSource>?
    
    var rssSourceModels: [RssSourceViewModel] {
        guard let models = self.fetchedResultsController?.fetchedObjects, !models.isEmpty else {
            return []
        }
        return models.map({ cdRssSource in
            return RssSourceViewModel(name: cdRssSource.name,
                                      link: cdRssSource.link,
                                      imageUrl: cdRssSource.imageUrl,
                                      description: cdRssSource.note,
                                      numberOfUnread: Int(cdRssSource.numberOfUnread))
        })
    }
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        super.init()
    
        self.configureFetchController()
    }
    
    private func configureFetchController() {
        let fetchRequest = NSFetchRequest<CDRssSource>(entityName: CDRssSource.entityName)
        fetchRequest.sortDescriptors = [CDRssSource.addingDate.ascending()]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.serviceLocator.rssPersistentContainer.mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        try? self.fetchedResultsController?.performFetch()
        self.fetchedResultsController?.delegate = self
    }
    
}

extension RssModelsListInteractorImpl: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
}
